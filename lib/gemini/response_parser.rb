module Gemini
  class ResponseParser
    def self.parse(response)
      return "Error: #{response.status}" unless response.success?
      raw_json = response.body.dig("candidates", 0, "content", "parts", 0, "text")
      raw_json.to_s.gsub(/```json|```/, "").strip
    end
  end
end
