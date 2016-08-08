module V1
  class BannerApi < Grape::API
    resources :banners do
      desc "获取banner"
      get do
        banners = Banner.all.order(created_at: :DESC).limit(4)
        presence banners, with: ::Entities::Banner
        status 200
      end
    end
  end
end
