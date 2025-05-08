class Admin::EmailOptimizationsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def create
    optimized = EmailService::EmailOptimizeService.new(
      params[:subject],
      params[:body],
      params[:tone]
    ).optimize_email

    @emails = optimized
    @contact = Contact.find_by(id: params[:contact_id])
    @contacts = Contact.is_decision_maker if @contact.nil?

    render "admin/emails/index"
  end
end
