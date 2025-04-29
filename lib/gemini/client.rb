module Gemini
  class Client
    def initialize(model: Rails.configuration.x.gemini[:default_model])
      @model = model
      @connection = Faraday.new do |f|
        f.request :json
        f.response :json, content_type: /\bjson$/
      end
    end

    def generate(prompt:, options: {})
      body = RequestBuilder.build(prompt, options)
      endpoint = Rails.configuration.x.gemini[:endpoint_template] % { model: @model }
      response = @connection.post(endpoint) do |req|
        req.params["key"] = Rails.configuration.x.gemini[:api_key]
        req.headers["Content-Type"] = "application/json"
        req.body = body
      end
      ResponseParser.parse(response)
    end
  end
end
