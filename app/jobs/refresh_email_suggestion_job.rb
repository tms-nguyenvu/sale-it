class RefreshEmailSuggestionJob < ApplicationJob
  queue_as :default

  def perform
    email_id = Email.joins(:email_trackings)
                    .group("emails.id")
                    .order("COUNT(email_trackings.id) DESC")
                    .limit(1)
                    .pluck(:id)
                    .first
    Rails.logger.info("[RefreshEmailSuggestionJob] Most clicked email ID: #{email_id}")
    return if email_id.blank?

    EmailSuggestion.where(email_id: email_id).destroy_all
    GenerateEmailSuggestionJob.perform_later(email_id)
  end
end
