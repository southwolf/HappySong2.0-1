module V1
  class DynamocApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20
    resources :dynamics do
      desc "新建动态"
      params do
        requires :token,   type: Integer,       desc: '用户访问令牌'
        requires :content, type: String,        desc: '内容'
        requires :keys,    type: Array[String], desc: '图片名集合'
        requires :address, type: String,        desc: '地理位置'
        optional :tags,    type: Array[String], desc: '标签集合'
      end
      post "/create" do
        authenticate!
        content = params[:content]
        address = params[:address]
        keys    = params[:keys]
        tags    = params[:tags]
        dynamic = current_user.dynamics.build( :content => content, :address => address, 
                                               :original_user_id => current_user.id)

        if dynamic.save
          keys.each do |key|
            dynamic.attachments.create(:file_url => key)
          end
         # tags.each do |tag|
          #   dynamic.addTag(tag)
          # end
        else
        end
      end
    end
  end
end
