module V1
  class WorkApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20
    resources :works do
      desc "老师发布朗读作业要求"
      params do
        requires :token,                type: String,     desc: '用户访问令牌'
        requires :content,              type: String,     desc: "作业详细要求"
        requires :article_ids,          type: String,     desc: "文章ID集合用空格隔开当作业类型为【朗读】时才有这个参数"
        requires :grade_team_class_ids, type: String,     desc: "班级ID集合用空格隔开"
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
          work = current_user.works.new( content: content, start_time: start_time, end_time: end_time, style: "record_work")
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
        requires :grade_team_class_ids, type: String,     desc: "班级ID集合用空格隔开"
        requires :start_time,           type: DateTime,   desc: "开始时间"
        requires :end_time,             type: DateTime,   desc: "结束时间"
      end
      post '/creative_work' do
        authenticate!
        content     = params[:content]
        picture_keys = params[:picture_keys]
        video_key   = params[:video_key]
        grade_team_class_ids = params[:grade_team_class_ids]
        start_time  = params[:start_time]
        end_time    = params[:end_time]

        Work.transaction do
          work = current_user.works.create!( content: content,
                                             start_time:start_time,
                                             end_time: end_time,
                                             style: "creative_work")

          grade_team_class_ids.split.each do |grade_team_class_id|
            grade_team_class = GradeTeamClass.find(grade_team_class_id)
            work.grade_team_classes << grade_team_class
          end

          if picture_keys.present?
            picture_keys.split.each do |picture_key|
              work.work_attachments.create(is_video: false, file_url: picture_key)
            end
          end
          if video_key.present?
            work.work_attachments.create(is_video: true, file_url: video_key)
          end
        end

        present :message, "成功"
      end

      desc "显示本人发布的朗读作业"
      params do
        requires :token, type: String, desc: '用户访问令牌'
      end
      get '/record_works' do
        authenticate!
        works = current_user.works.where(style: "record_work")
                                  .includes(:articles,:work_attachments)
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
                                  .includes(:articles,:work_attachments)
                                  .reverse
                                  .group_by{ |work| DateTime.parse(work.created_at.to_s).strftime('%Y-%-m')}.to_a
        present paginate(Kaminari.paginate_array(works)), with: ::Entities::HashWork

      end


      desc "显示作业详情"
      params do
        requires :work_id, type: Integer, desc: "作业ID"
      end

      get '/show_work_info' do
        work_id = params[:work_id]
        work = Work.find(work_id)

        present work, with: ::Entities::Work
      end

      desc "根据给定班级显示班级学生完成作业情况"
      params do
        requires :token, type: String, desc: '用户访问令牌'
        requires :work_id, type: Integer, desc: "作业ID"
        requires :grade_team_class_id, type: Integer, desc: "班级ID"
      end
      get '/complete_work_infos' do
        authenticate!
        work_id = params[:work_id]
        grade_team_class_id = params[:grade_team_class_id]
        grade_team_class = GradeTeamClass.find(grade_team_class_id)
        uncomplete_students = WorkToStudent.where(work_id: work_id, complete: true).includes(:student, student:[:role,:grade_team_class])
                                          .select { |work_to_student| work_to_student.student.grade_team_class == grade_team_class}
                                          .map { |work_to_student| work_to_student.student  }
        present paginate(Kaminari.paginate_array(uncomplete_students)), with: ::Entities::SimpleUser

      end


      desc "根据给定班级显示班级学生未完成作业情况"
      params do
        requires :token, type: String, desc: '用户访问令牌'
        requires :work_id, type: Integer, desc: "作业ID"
        requires :grade_team_class_id, type: Integer, desc: "班级ID"
      end
      get '/uncomplete_work_infos' do
        authenticate!
        work_id = params[:work_id]
        grade_team_class_id = params[:grade_team_class_id]
        grade_team_class = GradeTeamClass.find(grade_team_class_id)
        complete_student = WorkToStudent.where(work_id: work_id, complete: false).includes(:student, student:[:role,:grade_team_class])
                                          .select { |work_to_student| work_to_student.student.grade_team_class == grade_team_class}
                                          .map { |work_to_student| work_to_student.student  }
        present paginate(Kaminari.paginate_array(complete_student)), with: ::Entities::SimpleUser

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
        result = []
        current_user.children.each do |child|
          result += WorkToStudent.where(complete: true, student: child)
                                 .order(:created_at => :desc)
                                 .includes(:student, :work)
        end

        present paginate(Kaminari.paginate_array(result)), with: ::Entities::WorkToStudent
      end


      desc "家长查看子女未完成作业情况"
      params do
        requires :token, type: String, desc: '用户访问令牌'
      end
      get '/child_uncomplete_work_infos' do
        authenticate!
        result = []
        current_user.children.each do |child|
          result += WorkToStudent.where(complete: false, student: child)
                                 .order(:created_at => :desc)
                                 .includes(:student, :my_work)
        end
        present paginate(Kaminari.paginate_array(result)), with: ::Entities::WorkToStudent
      end



      desc "获取此朗读的目标文章"
      params do
        requires :work_id, type: Integer, desc: '作品ID'
      end
      get '/target_articles' do
        work = Work.find(params[:work_id])
        articles = work.articles

        present articles, with: ::Entities::Article
      end

      desc "检查是否朗读了此作业的指定文章"
      params do
        requires :token,      type: String,  desc: "令牌"
        requires :work_id,    type: Integer, desc: "作业要求ID"
        requires :article_id, type: Integer, desc: "文章ID"
      end
      get '/check_complete_article' do
        authenticate!
        work = Work.find(params[:work_id])
        article = Article.find(params[:article_id])
        if Record.where(work: work, article: article).nil?
          present :message, false
        else
          present :message, true
        end
      end

      desc "上传朗读作业"
      params do
        requires :token,      type: String,  desc: "令牌"
        requires :file_url,   type: String,  desc: "文件URL"
        requires :article_id, type: Integer, desc: "文章ID"
        requires :music_id,   type: Integer, desc: "音乐ID"
        requires :style,      type: String,  desc: "朗读类型【video,media】"
        requires :is_public,  type: Boolean, desc: "是否公开"
        optional :felling,    type: String,  desc: "感谢"
        requires :work_id,    type: Integer, desc: "作业ID"
      end
      post '/upload_record_work' do
        authenticate!
        file_url   = params[:file_url]
        article_id = params[:article_id]
        music_id   = params[:music_id]
        style      = params[:stype]
        is_public  = params[:is_public]
        felling    = params[:felling]
        work_id    = params[:work_id]
        record = current_user.records.new(
          file_url: file_url,
          article_id: article_id,
          music_id: music_id,
          style:    style,
          is_public: is_public,
          feeling:   felling,
          work_id: work_id,
          is_work: true
        )
        if record.save
          present :message, "成功"
        else
          present :message, "失败"
        end
      end


      desc "上传创作作业"
      params do
        requires :token,        type: String,  desc: '用户访问令牌'
        requires :content,      type: String,  desc: '内容'
        requires :address,      type: String,  desc: '地理位置'
        optional :picture_keys, type: String,  desc: '图片集合'
        optional :video_key,    type: String,  desc: '视频'
        optional :tags,         type: String,  desc: '标签集合用空格隔开'
        requires :work_id,      type: Integer, desc: "作业ID"
      end
      post '/upload_creative_word' do
        authenticate!
        content      = params[:content]
        address      = params[:address]
        picture_keys = params[:picture_keys]
        video_key    = params[:video_key]
        tags         = params[:tags]
        work_id      = params[:work_id]
        puts work_id
        dynamic      = current_user.dynamics.build( :content => content,
                                                    :address => address,
                                                    :work_id => work_id,
                                                    :is_work => true)
        if dynamic.save
          dynamic.update( :original_dynamic_id => dynamic.id)

          unless picture_keys.nil?
            picture_keys.split.each do |picture_key|
              dynamic.attachments.create( :file_url => picture_key,
                                          :is_video => false)
            end
          end
          unless video_key.nil?
            dynamic.attachments.create( :file_url => video_key,
                                        :is_video => true)
          end

          if tags.present?
            # 添加标签
            tags.split.each do |tag|
              dynamic.addTag(tag)
            end
          end
          present :message, "成功"
        else
          present :message, "失败"
        end
      end

      desc "学生查看自己作业完成情况"
      params do
        requires :token, type: String,  desc: '用户访问令牌'
      end

      get '/work_info_student' do
        authenticate!
        works = current_user.work_to_students.includes(:my_work, :student, my_work:[:articles,:work_attachments])
        present paginate(works), with: ::Entities::WorkToStudent
      end

      desc "查看完成作业的人"
      params do
        requires :work_id, type: Integer, desc: "作业ID"
      end
      get '/complete_work_users' do
        work_id = params[:work_id]
        work = Work.find(work_id)
        result = work.complete_users
        present  paginate(Kaminari.paginate_array(result)), with: ::Entities::User
      end


      desc "查看没有完成作业的人"
      params do
        requires :work_id, type: Integer, desc: "作业ID"
      end

      get '/uncomplete_work_users' do
        work_id = params[:work_id]
        work = Work.find(work_id)
        result = work.uncomplete_users
        present  paginate(Kaminari.paginate_array(result)), with: ::Entities::User
      end

      desc "评论作业"
      params do
        requires :token,      type: String,  desc: '用户访问令牌'
        requires :work_id,    type: Integer, desc: '动态ID'
        requires :content,    type: String,  desc: '评论内容'
      end
      post '/comment' do
        authenticate!
        work_id = params[:work_id]
        content    = params[:content]
        work    = Work.find(work_id)
        comment    = work.comments.build( :user_id => current_user.id,
                                          :content => content)
        if comment.save
          present message: "评论成功"
        else
          error!({error: "评论失败"}, 500)
        end
      end


      desc "判断这个文章作业是否读了"
      params do
        requires :token,      type: String,  desc: '用户访问令牌'
        requires :work_id,    type: Integer, desc: '动态ID'
        requires :article_id, type: Integer, desc: '文章ID'
      end

      get '/checkout' do
        authenticate!
        work_id = params[:work_id]
        article_id = params[:article_id]

        status = Record.where(is_work: true, work_id: work_id, article_id: article_id)

        if status.present?
          present :message, true
        else
          present :message, false
        end

      end
    end
  end
end
