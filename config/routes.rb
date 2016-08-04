Rails.application.routes.draw do
  mount Notifications::Engine => "/notifications"
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger_doc'
end
