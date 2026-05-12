RSpec.describe WebScrapingAI do
  describe WebScrapingAI::ApiError do
    it "exposes status, message, and details from the response body" do
      error = described_class.new(
        message: "Invalid CSS selector",
        status: 400,
        status_code: nil,
        status_message: nil,
        body: nil,
        response_body: '{"message":"Invalid CSS selector"}'
      )
      expect(error.message).to eq("Invalid CSS selector")
      expect(error.status).to eq(400)
      expect(error.response_body).to eq('{"message":"Invalid CSS selector"}')
    end
  end

  describe "STATUS_TO_ERROR" do
    it "maps each documented status to a specific error class" do
      expect(WebScrapingAI::STATUS_TO_ERROR).to eq(
        400 => WebScrapingAI::BadRequestError,
        402 => WebScrapingAI::PaymentRequiredError,
        403 => WebScrapingAI::AuthenticationError,
        429 => WebScrapingAI::RateLimitError,
        500 => WebScrapingAI::ServerError,
        504 => WebScrapingAI::GatewayTimeoutError
      )
    end
  end
end
