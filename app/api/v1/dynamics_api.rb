module V1
  class DynamocApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20
    resources :dynamics do
      desc "新建动态"
      params do
        requires :token,   type: Integer,       desc: '用户访问令牌'
        requires :content, type: String,        desc: '内容'
        optional :keys,    type: Array[String], desc: '图片名集合'
        requires :address, type: String,        desc: '地理位置'
        optional :tags,    type: Array[String], desc: '标签集合'
      end
      post "/create" do
        authenticate!
        content = params[:content]
        address = params[:address]
        keys    = params[:keys]
        tags    = params[:tags]
        dynamic = current_user.dynamics.build( :content => content,
                                               :address => address,
                                               :original_user_id => current_user.id)

        if dynamic.save
          # 添加附件
          keys.each do |key|
            dynamic.attachments.create(:file_url => key)
          end
          # 添加标签
          tags.each do |tag|
            dynamic.addTag(tag)
          end
          present dynamic, with: ::Entities::Dynamic
        else
          error!("失败", 500)
        end

      end

      desc "转发动态"
      params do
        requires :token,      type: String,        desc: "用户访问令牌"
        requires :dynamic_id, type: Integer,        desc: "动态ID"
        requires :content,    type: String,        desc: "内容"
        requires :tags,       type: Array[String], desc: "标签集合"
      end

      post "/forward" do
        authenticate!
        dynamic_id = params[:dynamic_id]
        content    = params[:content]
        tags       = params[:tags]
        dynamic = Dynamic.find(dynamic_id)
        ref_dynamic = dynamic.ref_dynamics.create( :user_id  => current_user.id,
                                     :content  => content,
                                     :is_relay => true,
                                     :original_dynamic_id => dynamic.original_dynamic_id)
        if ref_dynamic.save
          tags.each do |tag|
            ref_dynamic.addTag tag
          end
          present ref_dynamic, with: ::Entities::Dynamoc
        else
          error!("失败",500)
        end
      end
    end
  end
end
