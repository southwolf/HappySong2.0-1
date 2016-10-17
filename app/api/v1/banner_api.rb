module V1
  class BannerApi < Grape::API
    resources :banners do
      desc "获取banner"
      get do
        banners = Banner.all.order(created_at: :DESC).take(5)
        present banners, with: ::Entities::Banner
      end
    end
  end
end
