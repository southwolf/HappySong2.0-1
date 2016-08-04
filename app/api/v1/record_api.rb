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
      get do
        records = Record.all.order(:created_at => :DESC)
        present paginate(records), with: ::Entities::Record
      end

      desc "推荐朗读"

      get do

      end

      desc "根据获取朗读"
      params do
        requires :id, type: Integer, desc: "朗读作品ID"
      end
      get '/show' do
        id = params[:id]
        record = Record.find(id)
        if record.nil?
          error!({message: "没有找到对应朗读!"}, 404)
        else
          present record, with: ::Entities::Record
        end
      end

      
    end
  end
end
