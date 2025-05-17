class Admin::EmailAnalyticsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @emails_sent_count = Email.where(sent_at: current_month_range).count
    @click_rate = calculate_click_rate
    @reply_rate = calculate_reply_rate
    @most_opened_email = most_opened_email
    @most_replied_email = most_replied_email
  end

  private

  def calculate_click_rate
    sent_email_ids = Email.where(sent_at: current_month_range).pluck(:id)
    clicked_email_ids = EmailTracking.where(clicked_at: current_month_range)
                                     .where(email_id: sent_email_ids)
                                     .distinct.pluck(:email_id)

    return 0 if sent_email_ids.empty?

    ((clicked_email_ids.size.to_f / sent_email_ids.size) * 100).round(2)
  end

  def calculate_reply_rate
    sent_email_ids = Email.where(sent_at: current_month_range).pluck(:id)
    replied_email_ids = EmailReply.where(created_at: current_month_range)
                                  .where(email_id: sent_email_ids)
                                  .distinct.pluck(:email_id)

    return 0 if sent_email_ids.empty?

    ((replied_email_ids.size.to_f / sent_email_ids.size) * 100).round(2)
  end

  def current_month_range
    Time.current.beginning_of_month..Time.current.end_of_month
  end

  def most_opened_email
    Email
      .joins(:email_trackings)
      .where(email_trackings: { clicked_at: current_month_range })
      .group("emails.id")
      .order("COUNT(email_trackings.id) DESC")
      .limit(1)
      .first
  end

  def most_replied_email
    Email
      .joins(:email_replies)
      .where(email_replies: { created_at: current_month_range })
      .group("emails.id")
      .order("COUNT(email_replies.id) DESC")
      .limit(1)
      .first
  end
end
