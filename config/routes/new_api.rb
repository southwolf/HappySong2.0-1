namespace :new_api do
  scope module: :v1 do
    resources :nations, shallow: true, only: [:show] do
      scope module: :nations do
        resources :schools, only: [:index]
      end
    end
    resources :schools, shallow: true, only: [:index, :show, :create, :update] do
      scope module: :schools do
        resources :classes, only: [:create, :show, :index]
      end
    end

    resources :teachers, shallow: true, only: [:show, :index] do
      scope module: :teachers do
        resources :classes, only: [:index]
        resources :profile, only: [:index]
      end
    end

    resources :classes, shallow: true, only: [:index] do
      scope module: :classes do
        resources :students, only: [:index]
      end
    end
    resources :profiles, only: [:show]

    resources :cities, shallow: true, only: [:index] do
      scope module: :cities do
        resources :countries, only: [:index]
      end
    end

    resources :students, only: [] do 
      scope module: :students do
        resources :classes, only: [:index, :destroy, :create]
      end
    end
  end
end
