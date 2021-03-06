module V1
  class RecordApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20

    resources :records do
      desc "新建朗读"
      params do
        requires :token,      type: String,  desc: "token"
        requires :file_url,   type: String,  desc: "文件"
        requires :article_id, type: String,  desc: "文章ID"
        requires :music_id,   type: String,  desc: "背景音乐ID"
        requires :style,       type: String,  desc: "朗读类型【video, media】"
        requires :is_public,  type: Boolean, desc: "是否公开"
        optional :felling,    type: String,  desc: "感想"
      end

      post do
        authenticate!
        if current_user.role.name == "teacher"
          is_demo = true
        else
          is_demo = false
        end
        user_id = current_user.id
        record = Record.new( :user_id  => user_id,           :file_url   => params[:file_url],
                             :feeling  => params[:felling],  :article_id => params[:article_id],
                             :style    => params[:style],    :is_demo  => is_demo,
                             :music_id => params[:music_id], :is_public  => params[:is_public] )
        if record.save
          present  :message, "创建成功"
        else
          present :message, "创建失败"
        end
      end

      desc "更新朗读"
      params do
        requires :token,      type: String,  desc: "token"
        requires :record_id,  type: Integer, desc: "朗读ID"
        requires :is_public,  type: Boolean, desc: "是否公开"
        optional :felling,    type: String,  desc: "感想"
      end

      post '/update_record' do
        record = Record.find(params[:record_id])
        is_public = params[:is_public]
        felling   = params[:felling]
        if record.update( :is_public => is_public,
                       :feeling   => felling)
          present :message, "更新成功"
        else
          present :message, "更新失败"
        end
      end

      desc "举报动态"
      params do
        requires :token,      type: String,  desc: "用户访问令牌"
        requires :record_id, type: Integer, desc: "动态ID"
      end
      post '/report' do
        authenticate!
        record_id = params[:record_id]
        record = Record.find(record_id)
        if record.reports.create(:user_id => current_user.id)
          present :message, "举报成功"
        else
          error!({error: "失败"}, 500)
        end
      end

      desc "最新朗读"
      paginate per_page: 20
      get "/recent"do
        records = Record.public_records.order(:created_at => :DESC)
                                      .includes(:user,:music,
                                                :article, user: [:role, :grade_team_classes, :grade_team_class])
        present paginate(records), with: ::Entities::Record
      end

      desc "推荐朗读"
      paginate per_page: 20
      get "/recommend" do
        records = Record.find_by_sql("SELECT a.* FROM records as a join views as b on a.id = b.view_record_id
                          WHERE (b.`created_at` BETWEEN '#{Time.now - 1.day }' AND '#{Time.now}')
                          GROUP BY(a.id) ORDER BY count(b.num) DESC")
        if records.blank?
          records = Record.find_by_sql("SELECT a.* FROM records as a join views as b on a.id = b.view_record_id
                            WHERE (b.`created_at` BETWEEN '#{Time.now.beginning_of_week - 1.week }' AND '#{Time.now.beginning_of_week}')
                            GROUP BY(a.id) ORDER BY count(b.num) DESC")
        end
        present paginate(Kaminari.paginate_array(records)), with: ::Entities::Record
      end


      desc "作者姓名获取朗读结果"
      params do
        optional :q, type: String, desc: "查询参数"
      end
      get '/search' do
        q = params[:q]
        users = User.where("name like ?", "#{q}%")
        records     = Record.all.order(created_at: :DESC).includes(:article, :music,:user, user:[:role]) if q.nil?
        records     = Record.public_records.where(user: users).order(created_at: :DESC).includes(:article, :music,:user, user:[:role])
        #if records.blank?
         # error!({message: "没有找到对应朗读!"}, 404)
        #else
        present records, with: ::Entities::Record
        #end
      end

      desc "查看朗读"
      params do
        optional :token, type: String,  desc: "访问令牌"
        requires :id,    type: Integer, desc: "朗读作品的ID"
      end
      get '/show' do
        if params[:token]
          current_user = User.find_by_auth_token(params[:token])
        else
        end

        id = params[:id]
        record = Record.find(id)
        if record.blank?
          error!("没有找到", 404)
        else
          record.view_count += 1
          record.save
          puts "+1了"
          if current_user
            record.views.create(:viewer_id => current_user.id)
          else
            record.views.create
          end

          present record, with: ::Entities::Record

        end
      end

      desc "删除朗读"
      params do
        requires :token, type: String, desc: "用户访问令牌"
        requires :record_id, type: Integer, desc: '朗读ID'
      end

      post '/delete' do
        authenticate!
        record = Record.find(params[:record_id])
        if record.destroy
          present :message, "成功"
        else
          present :message, "删除失败"
        end
      end

      desc "作品点赞"
      params do
        requires :token, type: String,  desc: "访问令牌"
        requires :id,    type: Integer, desc: "朗读作品ID"
      end
      post '/like' do
        authenticate!
        id = params[:id].to_i
        record = Record.find(id)

        if record.like_users << current_user
          present message: "成功"
        else
          error!({error: "失败"}, 500)
        end
      end

      desc "作品取消点赞"
      params do
        requires :token, type: String, desc: "访问令牌"
        requires :id,    type: Integer, desc: "朗读作品ID"
      end
      post '/unlike' do
        authenticate!
        id = params[:id].to_i
        record = Record.find(id)
        if record.like_users.destroy current_user
          present message: "成功"
        else
          error!("失败", 500)
        end
      end

      desc "判断是否点赞"
      params do
        requires :token, type: String, desc: "访问令牌"
        requires :record_id, type: String, desc: "作品ID"
      end
      get '/checklike' do
       authenticate!
       record_id = params[:record_id]
       record    = Record.find(record_id)
       if record.like_users.include?(current_user)
         present message: true
       else
         present message: false
       end

      end

      desc "评论作品"
      params do
        requires :token,   type: String,   desc: "访问令牌"
        requires :id,      type: Integer,  desc: "朗读作品ID"
        requires :content, type: String,   desc: "评论内容"
      end

      post '/comment'do
        authenticate!
        id      = params[:id].to_i
        content = params[:content].to_s
        record  = Record.find(id)
        c       = record.comments.build(:content => content, :user_id => current_user.id)
        if c.save
          present message: "评论成功"
        else
          errors!({ error: "评论失败"}, 500)
        end
      end

      desc "根据朗读作品ID拉取评论"
      paginate per_page: 20
      params do
        requires :record_id, type: Integer, desc: '朗读作品ID'
      end

      get '/comments' do
        record_id = params[:record_id]
        record    = Record.find(record_id)

        comments  = record.comments
        present paginate(comments), with: Entities::CommentWithReply
      end

      desc "按月分组取个人朗读"
      params do
        requires :token, type: String, desc: "用户访问令牌"
      end
      get '/my_records' do
        authenticate!
        records = current_user.records.order(:created_at => :desc).group_by{ |record| DateTime.parse(record.created_at.to_s).strftime('%Y-%-m')}.to_a
        present paginate(Kaminari.paginate_array(records)), with: ::Entities::HashRecord
      end


      desc "根据时间查朗读"
      params do
        optional :token,   type: String,  desc: "用户访问令牌"
        optional :user_id, type: Integer, desc: "用户ID"
        requires :time,    type: String,  desc: "时间"
      end
      get '/time_records' do
        user_id = params[:user_id]
        time    = params[:time]
        if user_id.nil?
          authenticate!
          records = current_user.records.order(:created_at => :desc).select {|dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%Y-%-m') == time }
          present paginate(Kaminari.paginate_array(records)), with: ::Entities::Record
        else
          user = User.find(user_id)
          records = user.records.where(:is_public => true).order(:created_at => :desc).reject { |dynamic| DateTime.parse(dynamic.created_at.to_s).strftime('%Y-%-m') != time}
          present paginate(Kaminari.paginate_array(records)), with: ::Entities::Record
        end
      end

      desc "按月分组取个人公开朗读"
      params do
        # requires :token, type: String, desc: "用户访问令牌"
        requires :id, type: Integer, desc: "用户Id"
      end
      get '/other_records' do
        user = User.find(params[:id])
        records = user.records.where(is_public: true).order(:created_at => :desc).group_by{ |record| DateTime.parse(record.created_at.to_s).strftime('%Y-%-m')}.to_a
        present paginate(Kaminari.paginate_array(records)), with: ::Entities::HashRecord
      end
      desc "获取教师朗读总篇数"
      params do
        requires :teacher_id, type: Integer, desc: "教师ID"
      end

      get '/count' do
         teacher = User.find(params[:teacher_id])
         records_count = teacher.records.size
         present :count, records_count
      end
    end
  end
end
