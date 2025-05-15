class GenerateLeadSuggestionJob < ApplicationJob
  queue_as :default

  def perform(lead_id)
    lead = Lead.find_by(id: lead_id)
    return if !lead

    email_replies = EmailReply.where(contact_id: lead.contact_id)
    last_reply = email_replies.order(created_at: :desc).first

    suggestion = SaleService::SaleSuggestionService.suggest_next_action(
      status: lead.status,
      last_contact_date: last_reply&.created_at,
      interaction_count: email_replies.count,
      last_customer_response: last_reply&.body&.truncate(100),
      priority: lead.priority,
      last_interaction: lead.last_interaction
    )

    lead.update(suggestions: suggestion)
  end
end
