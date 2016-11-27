namespace :new_api do
  scope module: :v1 do
    resources :team_classes, only: [:index, :destroy]
    resources :schools, shallow: true, only: [:index, :show, :create, :update] do
      resources :classes, only: [:create, :show, :index]
    end
    resources :classes, only: [:index]
    resources :cities, shallow: true, only: [:index] do
      scope module: :cities do
        resources :countries, only: [:index]
      end
    end
  end
end