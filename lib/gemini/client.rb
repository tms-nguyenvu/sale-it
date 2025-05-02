module Gemini
  class Client
    MAX_RETRIES = 3
    RETRY_DELAY = 2

    def initialize(model: Rails.configuration.x.gemini[:default_model])
      @model = model
      @connection = Faraday.new do |f|
        f.request :json
        f.response :json, content_type: /\bjson$/
      end
    end

    def generate(prompt:, options: {})
      retry_count = 0

      begin
        body = RequestBuilder.build(prompt, options)
        endpoint = Rails.configuration.x.gemini[:endpoint_template] % { model: @model }

        response = @connection.post(endpoint) do |req|
          req.params["key"] = Rails.configuration.x.gemini[:api_key]
          req.headers["Content-Type"] = "application/json"
          req.body = body
        end

        ResponseParser.parse(response)

      rescue Faraday::ClientError => e
        if e.response && e.response[:status] == 429 && retry_count < MAX_RETRIES
          retry_count += 1
          Rails.logger.warn("Gemini API 429 detected. Retrying #{retry_count}/#{MAX_RETRIES} after #{RETRY_DELAY} seconds...")
          sleep RETRY_DELAY
          retry
        else
          Rails.logger.error("Gemini API error: #{e.message}")
          raise
        end
      end
    end
  end
end
