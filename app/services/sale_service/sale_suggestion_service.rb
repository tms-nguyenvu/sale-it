module SaleService
  class SaleSuggestionService
    class << self
      def suggest_next_action(status:, last_contact_date:, interaction_count:, last_customer_response:, priority:, last_interaction:)
        prompt = I18n.t("ai.email_suggestions.generate_suggestions_prompt",
          status: status,
          last_contact_date: last_contact_date,
          interaction_count: interaction_count,
          last_customer_response: last_customer_response,
          priority: priority,
          last_interaction: last_interaction
        )

        Gemini::GenerateContent.call(prompt: prompt)
      end
    end
  end
end
