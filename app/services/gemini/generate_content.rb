module Gemini
  class GenerateContent
    def self.call(prompt:, model: :flash, tools: nil)
      client = ::Gemini::Client.new(model: Rails.configuration.x.gemini[:models][model])
      client.generate(prompt: prompt, options: {  tools: tools })
    end
  end
end
