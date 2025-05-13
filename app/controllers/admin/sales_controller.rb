class Admin::SalesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  POTENTIAL_SCORE_THRESHOLD = 70

  def index
    @companies = Company.includes(:contacts)
                        .where("potential_score >= ?", POTENTIAL_SCORE_THRESHOLD)
                        .order(potential_score: :desc)
    @new_leads = Lead.where(status: 0)
    @email_sent_leads = Lead.where(status: 1)
    @email_replied_leads = Lead.where(status: 2)
    @demo_leads = Lead.where(status: 3)
    @negotiate_leads = Lead.where(status: 4)
  end

  def create
    leads = Lead.new(sale_params)
    if leads.save
      redirect_to admin_sales_path, notice: "Sale was successfully created."
    else
      redirect_to admin_sales_path, alert: "Failed to create sale."
    end
  end


  private

  def sale_params
    params.permit(:company_id, :contact_id, :manager_id, :note)
  end
end
