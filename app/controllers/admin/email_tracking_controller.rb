class Admin::EmailTrackingController < ApplicationController
  SAFE_DOMAINS = [
    "https://tomosia.com.vn",
  ].freeze

  def track_click
    email = Email.where(contact_id: params[:contact_id]).order(sent_at: :desc).first
    email&.email_trackings&.create!(clicked_at: Time.current)

    target_url = params[:target].to_s

    if SAFE_DOMAINS.any? { |domain| target_url.start_with?(domain) }
      redirect_to target_url, allow_other_host: true
    else
      redirect_to root_path, alert: "Invalid redirect target"
    end
  end
end
