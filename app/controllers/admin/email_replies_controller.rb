class Admin::EmailRepliesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @q = Email.ransack(params[:q])
    @emails = @q.result.includes(:contact, :user).order(sent_at: :desc)
  end



  def create
    @reply = EmailReply.new(
      email_id: params[:email_id],
      contact_id: Email.find(params[:email_id]).contact_id,
      user_id: current_user.id,
      body: params[:body],
      received_at: Time.current
    )

    if @reply.save
      redirect_to admin_email_replies_path, notice: "Reply was successfully created."
    else
      redirect_to admin_email_replies_path, alert: "Failed to create reply."
    end
  end
end
