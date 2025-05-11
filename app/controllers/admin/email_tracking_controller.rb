class Admin::EmailTrackingController < ApplicationController
  SAFE_DOMAINS = [ "tomosia.com.vn" ].freeze

  def safe_redirect_url(target_url)
    uri = URI.parse(target_url)
    if uri.host.present? && SAFE_DOMAINS.include?(uri.host)
      target_url
    else
      root_path
    end
  rescue URI::InvalidURIError
    root_path
  end

  def track_click
    email = Email.where(contact_id: params[:contact_id]).order(sent_at: :desc).first
    email&.email_trackings&.create!(clicked_at: Time.current)

    redirect_to safe_redirect_url(params[:target])
  end
end
