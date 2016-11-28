namespace :new_api do
  scope module: :v1 do
    resources :team_classes, only: [:index, :destroy]
    resources :schools, only: [:index, :show, :create, :update] do
      resources :classes, only: [:create, :show, :index]
    end

    namespace :classes do
      resources :search, only: [:create]
    end

    resources :classes, only: [:index] do
      collection do
        get :by_code
      end
    end

    resources :cities, shallow: true, only: [:index] do
      scope module: :cities do
        resources :countries, only: [:index]
      end
    end
  end
end
