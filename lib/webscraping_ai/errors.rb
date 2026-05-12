module WebScrapingAI
  class Error < StandardError; end

  class ConfigurationError < Error; end

  class ConnectionError < Error; end

  class TimeoutError < Error; end

  class ApiError < Error
    attr_reader :status, :status_code, :status_message, :body, :response_body

    def initialize(message:, status:, status_code: nil, status_message: nil, body: nil, response_body: nil)
      super(message)
      @status = status
      @status_code = status_code
      @status_message = status_message
      @body = body
      @response_body = response_body
    end
  end

  # 400
  class BadRequestError < ApiError; end
  # 402 — out of credits
  class PaymentRequiredError < ApiError; end
  # 403 — wrong API key
  class AuthenticationError < ApiError; end
  # 429 — too many concurrent requests
  class RateLimitError < ApiError; end
  # 500
  class ServerError < ApiError; end
  # 504
  class GatewayTimeoutError < ApiError; end

  STATUS_TO_ERROR = {
    400 => BadRequestError,
    402 => PaymentRequiredError,
    403 => AuthenticationError,
    429 => RateLimitError,
    500 => ServerError,
    504 => GatewayTimeoutError
  }.freeze
end
