class Admin::EmailsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @contacts = Contact.is_decision_maker
    @emails = EmailService::EmailContentService.new(@contacts, nil, current_user).generate_content(params[:tone] || "professional")
    @history_emails = Email.all
  end

  def new
    if params[:contact_id].present?
      @contact = Contact.find(params[:contact_id])
    else
      @contact = Contact.is_decision_maker.first
      redirect_to admin_emails_path(tone: params[:tone]), alert: "No contacts available." if @contact.nil?
    end

    @emails = EmailService::EmailContentService.new(nil, @contact, current_user).generate_content(params[:tone] || "professional")
    render :index
  end


  def create
    begin
      Email.create!(
        subject: params[:subject],
        body: params[:body],
        contact_id: params[:email][:contact_id],
        user_id: current_user.id,
        status: :sent,
        tone: params[:tone].to_s || "professional",
        sent_at: Time.current
      )
    ContactMailer.outreach_email(params[:body], params[:subject]).deliver_now

    redirect_to admin_emails_path, notice: "Email sent successfully!"
    rescue StandardError => e
      logger.error "Error sending email: #{e.message}"
      flash.alert = e.message
      redirect_to admin_emails_path, alert: "Error sending email: #{e.message}"
    end
  end

  private

  def email_params
    params.require(:email).permit(:subject, :body, :contact_id, :tone)
  end
end
