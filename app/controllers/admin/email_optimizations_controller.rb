class Admin::EmailOptimizationsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def create
    begin
      optimized = EmailService::EmailOptimizeService.new(
        params[:subject],
        params[:body],
        params[:tone]
      ).optimize_email

      if optimized.present? && optimized[:subject].present? && optimized[:body].present?
        @emails = optimized
        flash.now[:notice] = "Optimized email generated successfully"
      else
        @emails = { subject: params[:subject], body: params[:body] }
        flash.now[:alert] = "Optimization failed. Please try again or check your input."
      end
    rescue => e
      @emails = { subject: params[:subject], body: params[:body] }
      flash.now[:alert] = "Something went wrong: #{e.message}"
    end

    @contact = Contact.find_by(id: params[:contact_id])
    @contacts = Contact.is_decision_maker if @contact.nil?

    render "admin/emails/index"
  end
end
