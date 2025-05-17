class GenerateEmailSuggestionJob < ApplicationJob
  queue_as :default

  def perform(email_id)
    email = Email.find_by(id: email_id)
    return unless email

    response = EmailService::EmailSuggestionsService.effective_email(
      subject: email.subject,
      body: email.body,
    )

    parsed = JSON.parse(response) rescue {}
    return if parsed.blank?

    email.create_email_suggestion!(data: parsed)
  end
end
