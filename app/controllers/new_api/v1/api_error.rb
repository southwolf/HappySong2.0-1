module NewApi
  module V1
    class ApiError < ActionController::Base
      attr :code, :text, :status

      def initialize(opts = {})
        @code = opts.fetch(:code, 2000)
        @text = opts.fetch(:text, '')
        @status = opts.fetch(:status, 400)
      end
    end
  end
end
