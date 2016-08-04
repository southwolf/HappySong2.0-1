require_rel '**/*.rb'
module V1
  class Base < Grape::API
    format :json
    prefix 'api'
    version 'v1', using: :path
    rescue_from :all

    helpers BaseHelpers

    mount V1::UsersApi
    mount V1::ProvincesApi
    mount V1::SchoolsApi
    mount V1::TeamClassesApi
    mount V1::MusicApi
    mount V1::SubjectApi
    mount V1::ArticleApi
    # add_swagger_documentation(
    #   :api_version => "api/v1",
    #   hide_documentation_path: true,
    #   hide_format: true
    # )
    add_swagger_documentation(
      add_version: true,
      api_version: 'api/v1'
    )
  end
end
