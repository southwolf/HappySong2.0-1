module V1
  class RecordApi < Grape::API
    include Grape::Kaminari
    resources :records do
      desc "新建朗读"
      params do
        requires :token,      type: String,  desc: "token"
        requires :file_url,   type: String,  desc: "文件"
        requires :article_id, type: String,  desc: "文章ID"
        requires :music_id,   type: String,  desc: "背景音乐ID"
        requires :type,       type: String,  desc: "朗读类型"
        requires :is_public,  type: Boolean, desc: "是否公开"
        optional :felling,    type: String,  desc: "感想"
      end

      post do
        authenticate!
        user_id = current_user.id
        result = Result.new( :user_id  => user_id,           :file_url   => params[:file_url],
                             :felling  => params[:felling],  :article_id => params[:article_id],
                             :music_id => params[:music_id], :is_public  => params[:is_public] )
        if result.save
          present :result, result, with: ::Entities::Result
        else
          error({message:"创建失败"}, 501)
        end
      end


      desc "最新朗读"
      paginate per_page: 20
      get "/recent"do
        records = Record.where(:is_public => true ).order(:created_at => :DESC)
        present paginate(records), with: ::Entities::Record
      end

      desc "推荐朗读"
      paginate per_page: 20
      get "/recommend" do
        records = Record.where(:is_public => true ).order(:view_count => :DESC)
        present paginate(records), with: ::Entities::Record
      end


      desc "根据文章标题或作者姓名获取朗读结果"
      params do
        optional :q, type: String, desc: "查询参数"
      end
      get '/search' do
        q = params[:q]
        records     = Record.all.order(created_at: :DESC) if q.nil?
        article_ids = Article.where("title=? OR author=?", q, q).pluck(:id)
        records     = Record.where(:article_id => article_ids)
        #if records.blank?
         # error!({message: "没有找到对应朗读!"}, 404)
        #else
        present records, with: ::Entities::Record
        #end
      end

      desc "查看朗读"
      params do
        requires :token, type: String,  desc: "访问令牌"
        requires :id,    type: Integer, desc: "朗读作品的ID"
      end
      get '/show' do
        authenticate!

        id = params[:id]
        record = Record.find(id)
        if record.blank?
          error!("没有找到", 404)
        else
          record.view_count += 1
          present record, with: ::Entities::Record

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
          present "成功"
        else
          error!("失败", 500)
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
          present "评论成功"
        else
          errors!("评论失败", 500)
        end
      end
    end
  end
end
