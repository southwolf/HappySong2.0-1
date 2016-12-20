namespace :new_api do
  scope module: :v1 do
    resources :nations, shallow: true, only: [:show] do
      scope module: :nations do
        resources :schools, only: [:index]
      end
    end

    resources :works, only: [] do
      scope module: :works do
        resources :finished_students, only: [:index]
        resources :unfinished_students, only: [:index]
        resources :check_states, only: [:index]
      end
    end

    resources :classes, only: [:index, :show] do
      collection do
        get :code
      end
      scope module: :classes do
        resources :students, only: [:index]
        resources :finished_students, only: [:index]
        resources :unfinished_students, only: [:index]
      end
    end

    resources :schools, shallow: true, only: [:index, :show, :create, :update] do
      scope module: :schools do
        resources :classes, only: [:create, :index]
      end
    end

    resources :teachers, shallow: true, only: [:show, :index] do
      scope module: :teachers do
        resources :classes, only: [:index]
        resources :profile, only: [:index]
        resources :works, only: [:create, :destroy, :index, :show, :update] # 作业需要有增删改查
        resources :records, only: [:create, :index] do
          collection do
            get :month
          end
        end
        resources :dynamics, only: [:create, :index] do
          collection do
            get :month
          end
        end
      end
    end

    resources :profiles, only: [:show]
    resources :orders, only: [:create]
    namespace :pingpp do
      resources :webhooks, only: [:create]
    end

    resources :cities, shallow: true, only: [:index] do
      scope module: :cities do
        resources :countries, only: [:index]
      end
    end

    resources :students, only: [:show, :index] do
      scope module: :students do
        resources :classes, only: [:index, :destroy, :create]
        resources :profile, only: [:index]
        resources :works, only: [:index, :show]
      end
    end
  end
end
