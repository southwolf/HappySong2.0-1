module V1
  class DynamocApi < Grape::API
    include Grape::Kaminari
    paginate per_page: 20
  end
end
