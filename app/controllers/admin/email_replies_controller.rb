class Admin::EmailRepliesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @q = Email.ransack(params[:q])
    @pagy, @emails = pagy(@q.result.includes(:contact, :user, :email_replies).order(sent_at: :desc), limit: 6)
    @email_suggestions = EmailSuggestion.all
  end

  def create
    email = Email.find_by(id: params[:email_id])
    lead = Lead.find_by(id: email.lead_id)
    unless email
      redirect_to admin_email_replies_path, alert: "Email not found." and return
    end

    @reply = EmailReply.new(
      email_id: email.id,
      contact_id: email.contact_id,
      user_id: current_user.id,
      body: params[:body],
      received_at: Time.current,
    )
    if lead
      lead.update(status: "replied")
      GenerateLeadSuggestionJob.perform_later(lead.id)
      Rails.logger.info("Updated Lead ID #{lead.id} to status: email_sent")
    else
      Rails.logger.warn("No Lead found for contact_id: #{email.contact_id}")
    end

    if @reply.save
      ai_input = {
        email: {
          subject: email.subject,
          body: email.body,
          tone: email.tone,
          email_type: email.email_type,
          sent_at: email.sent_at
        },
        reply: {
          body: @reply.body,
          received_at: @reply.received_at,
          contact_name: @reply.contact&.name,
          company_name: @reply.contact&.company&.name
        }
      }

      raw_json = EmailService::EmailSuggestionsService.suggested_action(ai_input: ai_input)
      suggestion = JSON.parse(raw_json, symbolize_names: true)

      email_suggestion = EmailSuggestion.find_or_initialize_by(email_id: @reply.email_id)
      email_suggestion.update!(
        suggested_action: suggestion[:suggested_action],
        reasoning: suggestion[:reasoning]
      )

      redirect_to admin_email_replies_path, notice: "Reply was successfully created."
    else
      Rails.logger.error("Failed to create reply: #{@reply.errors.full_messages}")
      redirect_to admin_email_replies_path, alert: "Failed to create reply."
    end
  rescue JSON::ParserError, StandardError => e
    Rails.logger.error("Error generating suggestion: #{e.message}")
    redirect_to admin_email_replies_path, alert: "Reply created, but failed to generate suggestion."
  end
end
