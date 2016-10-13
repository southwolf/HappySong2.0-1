module V1
  class WorkApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20
    resources :works do
      desc "老师发布朗读作业要求"
      params do
        requires :token,                type: String, desc: '用户访问令牌'
        requires :content,              type: String,   desc: "作业详细要求"
        requires :article_ids,          type: String, desc: "文章ID集合用空格隔开当作业类型为【朗读】时才有这个参数"
        requires :grade_team_class_ids, type: String, desc: "班级ID集合用空格隔开"
        requires :start_time,           type: DateTime,   desc: "开始时间"
        requires :end_time,             type: DateTime,   desc: "结束时间"
      end
      post '/record_work' do
        authenticate!
        content              = params[:content]
        article_ids         = params[:article_ids]
        grade_team_class_ids = params[:grade_team_class_ids]
        start_time           = params[:start_time]
        end_time             = params[:end_time]

        Work.transaction do
          work = current_user.works.new( content: content, start_time: start_time, end_time: end_time, style: "record")
          if work.save!
            article_ids.split.each do |article_id|
              article = Article.find(article_id)
              work.articles << article
            end
            grade_team_class_ids.split.each do |grade_team_class_id|
              grade_team_class = GradeTeamClass.find(grade_team_class_id)
              work.grade_team_classes << grade_team_class
            end
          end
        end
        present :message, "成功"
      end

      desc "老师发布创作作业要求"
      params do
        requires :token,                type: String,     desc: '用户访问令牌'
        requires :content,              type: String,     desc: "作业详细要求"
        optional :picture_keys,         type: String,     desc: "图片集合用空格隔开"
        optional :video_key,            type: String,     desc: "视频url"
        requires :start_time,           type: DateTime,   desc: "开始时间"
        requires :end_time,             type: DateTime,   desc: "结束时间"
      end
      post '/creative_work' do
        authenticate!
        content     = params[:content]
        picture_keys = params[:picture_keys]
        video_key   = params[:video_key]
        start_time  = params[:start_time]
        end_time    = params[:end_time]

        Work.transaction do
          work = current_user.works.create!( content: content,
                                             start_time:start_time,
                                             end_time: end_time,
                                             style: "creative_work")
          if picture_keys.present?
            picture_keys.split.each do |picture_key|
              work.work_attachments.create(is_video: false, file_url: picture_key)
            end
          end
          if video_key.present?
            work.work_attachments.create(is_video: true, file_url: video_key)
          end
        end
      end

      desc "显示本人发布的朗读作业"
      params do
        requires :token, type: String, desc: '用户访问令牌'
      end
      get '/record_works' do
        authenticate!
        works = current_user.works.where(style: "record_work")
                                  .includes( :teacher,
                                             :grade_team_classes, :students,
                                             :articles,:work_attachments,
                                             teacher:[:role,:member], students:[:role,:member],
                                             grade_team_classes:[:teacher,:school,:grade,:students, :team_class])
                                  .reverse
                                  .group_by{ |work| DateTime.parse(work.created_at.to_s).strftime('%Y-%-m')}.to_a

       present paginate(Kaminari.paginate_array(works)), with: ::Entities::HashWork
      end


      desc '显示本人发布的创作作业'
      params do
        requires :token, type: String, desc: '用户访问令牌'
      end
      get '/creative_works' do
        authenticate!
        works = current_user.works.where(style: "creative_work")
                                  .includes( :teacher,
                                             :grade_team_classes, :students,
                                             :articles,:work_attachments,
                                             teacher:[:role,:member], students:[:role,:member],
                                             grade_team_classes:[:teacher,:school,:grade,:students, :team_class])
                                  .reverse
                                  .group_by{ |work| DateTime.parse(work.created_at.to_s).strftime('%Y-%-m')}.to_a
        present paginate(Kaminari.paginate_array(works)), with: ::Entities::HashWork

      end


      desc "根据给定班级显示班级学生完成作业情况"
      params do
        requires :token, type: String, desc: '用户访问令牌'
        requires :work_id, type: Integer, desc: "作业ID"
        requires :grade_team_class_id, type: Integer, desc: "班级ID"
      end
      get '/work_info' do
        authenticate!
        work_id = params[:work_id]
        grade_team_class_id = params[:grade_team_class_id]
        grade_team_class = GradeTeamClass.find(grade_team_class_id)
        complete_student = WorkToStudent.where(work_id: work_id, complete: true).includes(:student, student:[:role,:grade_team_class])
                                        .select { |work_to_student| work_to_student.student.grade_team_class == grade_team_class}
                                        .map { |work_to_student| work_to_student.student  }
        uncomplete_student = WorkToStudent.where(work_id: work_id, complete: false).includes(:student, student:[:role,:grade_team_class])
                                          .select { |work_to_student| work_to_student.student.grade_team_class == grade_team_class}
                                          .map { |work_to_student| work_to_student.student  }
        present :complete_student,   complete_student, with: ::Entities::SimpleUser
        present :uncomplete_student, uncomplete_student, with: ::Entities::SimpleUser

      end

      desc "获取作业的评论列表"
      params do
        requires :work_id, type: Integer, desc: "作业的ID"
      end
      get '/comments' do
        work_id = params[:work_id]
        work    = Work.find(work_id)
        comments = work.comments.includes(:own_replys, :user)

        present paginate(comments), with: ::Entities::Comment
      end

      desc "根据用户ID查询用户完成的当前作业"
      params do
        requires :user_id, type: Integer, desc: "用户ID"
        requires :work_id, type: Integer, desc: "作业ID"
      end
      get '/complete_work_info' do
        work = Work.find(params[:work_id])
        user = User.find(params[:user_id])
        if work.style == "record_work"
          result = Record.where(user: user, work: work)
          present result, with: ::Entities::Record
        else
          result = Dynamic.where(user: user, work: work)
          present result, with: ::Entities::Dynamic
        end
      end


      desc "家长查看子女已经完成作业情况"
      params do
        requires :token, type: String, desc: '用户访问令牌'
      end

      get '/child_work_infos' do
        authenticate!
        current_user.children.each do |child|
          result += WorkToStudent.where(complete: true, user: child)
                                 .order(:created_at => :desc)
                                 .includes(:user, :work)
        end

        present result, with: ::Entities::WorkToStudent
      end


      desc "家长查看子女未完成作业情况"

      params do
        requires :token, type: String, desc: '用户访问令牌'
      end

      get '/child_uncomplete_work_infos' do
        authenticate!
        current_user.children.each do |child|
          result += WorkToStudent.where(complete: false, user: child)
                                 .order(:created_at => :desc)
                                 .includes(:user, :work)
        end

        present result, with: ::Entities::WorkToStudent
      end

      
    end
  end
end
