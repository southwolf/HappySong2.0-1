root 'web/home#index'

namespace :web do
  resources :home, only: [:index]
end