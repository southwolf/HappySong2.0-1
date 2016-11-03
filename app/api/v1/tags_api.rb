module V1
  class TagsApi < Grape::API
    resources :tags do
      desc "获取建议Tags"
      get '/tags' do
        tags = Tag.recommend.order(:tag_heat => :desc)
        present tags, with: ::Entities::Tag
      end

      desc "搜索标签"

      params do
        requires :tag_name, type: String, desc: "标签名称"
      end
      get '/search_tags' do
        tag_name = params[:tag_name]
        tags = Tag.where(:recommend => false).where("name like ?", "#{tag_name}%").order(:tag_heat => :desc)
        present tags, with: ::Entities::Tag
      end
    end
  end
end
