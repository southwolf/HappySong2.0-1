module V1
  class TagsApi < Grape::API
    resources :tags do
      desc "获取建议Tags"
      get '/tags' do
        tags = Tag.recommend
        present tags, with: ::Entities::Tag
      end
    end
  end
end
