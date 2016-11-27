module NewApi
  module V1
    class ApiError < StandardError
      attr :code, :text, :status

      def initialize(opts = {})
        @code = opts.fetch(:code, 2000)
        @text = opts.fetch(:text, '')
        @status = opts.fetch(:status, 400)
      end
    end

    class RecordNotFound < ApiError
      def initialize
        super code: 1102, text: "Record not found.", status: 404
      end
    end
  end
end
