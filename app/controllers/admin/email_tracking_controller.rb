class Admin::EmailTrackingController < ApplicationController
  def track_click
    email = Email.where(contact_id: params[:contact_id]).order(sent_at: :desc).first

    if email
      email.email_trackings.create!(clicked_at: Time.current)
    end

    redirect_to params[:target], allow_other_host: true
  end
end
