module Gemini
  class RequestBuilder
    def self.build(prompt, options = {})
      contents = [
        {
          role: "user",
          parts: [ { text: prompt } ]
        }
      ]

      request = {
        contents: contents,
        generationConfig: {
          temperature: 0.2,
          topK: 1,
          topP: 1
        }
      }

      # Function calling
      if options[:tools]
        request[:tools] = options[:tools]
      end

      request
    end
  end
end
