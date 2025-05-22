class Admin::EmailTrackingsController < ApplicationController
  SAFE_DOMAINS = [ "tomosia.com.vn", "www.tomosia.com.vn" ].freeze

  def index
    email = Email.where(contact_id: params[:contact_id]).order(sent_at: :desc).first
    email&.email_trackings&.create!(clicked_at: Time.current)

    lead = Lead.find_by(contact_id: email.contact_id)
    if lead
      lead.update(status: "replied")
      GenerateLeadSuggestionJob.perform_later(lead.id)
    end
    target_url = params[:target].presence || root_path

    begin
      uri = URI.parse(target_url)
      redirect_url = (uri.host.present? && SAFE_DOMAINS.include?(uri.host)) ? target_url : root_path
    rescue URI::InvalidURIError
      redirect_url = root_path
    end

    redirect_to redirect_url, allow_other_host: true
  end
end
