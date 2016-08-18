require_rel '**/*.rb'
module V1
  class Base < Grape::API
    format :json
    prefix 'api'
    version 'v1', using: :path
    rescue_from :all

    helpers BaseHelpers
    helpers RecordHelpers

    mount V1::UsersApi
    mount V1::ProvincesApi
    mount V1::SchoolsApi
    mount V1::TeamClassesApi
    mount V1::MusicApi
    mount V1::SubjectApi
    mount V1::ArticleApi
    mount V1::BannerApi
    mount V1::RecordApi
    mount V1::CommentsApi
    mount V1::SchoolManagerApi
    mount V1::QiniuUptoken
    # mount V1::DynamicsApi

    add_swagger_documentation(
      add_version: true,
      api_version: 'api/v1'
    )
  end
end
