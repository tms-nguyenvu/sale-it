module Gemini
  class ResponseParser
    def self.parse(response)
      return "Error: #{response.status}" unless response.success?
      response.body.dig("candidates", 0, "content", "parts", 0, "text")
    end
  end
end
