class Admin::EmailsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @contacts = Contact.is_decision_maker
    @emails = EmailService::EmailContentService.new(@contacts, nil, current_user).generate_content(params[:tone] || "professional")
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

  private

  def email_params
    params.require(:email).permit(:subject, :body, :contact_id)
  end
end
