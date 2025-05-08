require "json"

module EmailService
  class EmailOptimizeService
    def initialize(subject, body, tone)
      @subject = subject
      @body = body
      @tone = tone
    end

    def optimize_email
      prompt = I18n.t("ai.email_outreach.generate_email_prompt", subject: @subject, body: @body, tone: @tone)
      raw = Gemini::GenerateContent.call(prompt: prompt)

      JSON.parse(raw, symbolize_names: true)
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse AI response: #{e.message}")
      { subject: @subject, body: @body }
    end
  end
end
