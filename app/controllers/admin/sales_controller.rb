class Admin::SalesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_lead, only: [ :update ]

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

  def update
    if @lead.update(sale_params)
      redirect_to admin_sales_path, notice: "Sale was successfully updated."
    else
      flash[:alert] = @lead.errors.full_messages.to_sentence
      redirect_to admin_sales_path
    end
  end

  private

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def sale_params
    params.require(:lead).permit(
      :company_id,
      :contact_id,
      :manager_id,
      :note,
      :project_name,
      :status,
      :priority,
      :start_date,
      :end_date,
      :tag_list
    )
  end
end
