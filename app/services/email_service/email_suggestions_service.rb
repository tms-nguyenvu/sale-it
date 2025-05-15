module EmailService
  class EmailSuggestionsService
    class << self
      def effective_email(subject:, body:)
        prompt = I18n.t("ai.email_suggestions.generate_email_prompt",
                      subject: subject,
                      body: body,
                      )
        Gemini::GenerateContent.call(prompt: prompt)
      end

      def suggested_action(ai_input:)
        prompt = I18n.t("ai.email_suggestions.generate_suggestions_action_prompt",
          ai_input: ai_input
        )
        Gemini::GenerateContent.call(prompt: prompt)
      end
    end
  end
end
