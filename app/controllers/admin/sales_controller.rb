class Admin::SalesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_lead, only: [ :update ]

  POTENTIAL_SCORE_THRESHOLD = 70

  def index
    @companies = Company.includes(:contacts)
                        .where("potential_score >= ?", POTENTIAL_SCORE_THRESHOLD)
                        .order(potential_score: :desc)
    @new_leads = Lead.where(status: :new_lead)
    @email_sent_leads = Lead.where(status: :sent)
    @email_replied_leads = Lead.where(status: :replied)
    @demo_leads = Lead.where(status: :demo)
    @negotiate_and_closed_leads = Lead.where(status: [ :negotiate, :closed ])

    @lead_suggestions = Lead.where.not(suggestions: nil)
  end

  def create
    lead = Lead.new(sale_params)
    authorize! :update, lead
    if lead.save
      GenerateLeadSuggestionJob.perform_later(lead.id)
      redirect_to admin_sales_path, notice: "Sale was successfully created."
    else
      redirect_to admin_sales_path, alert: "Failed to create sale."
    end
  end

  def update
    authorize! :update, @lead
    if @lead.update(sale_params)
      GenerateLeadSuggestionJob.perform_later(@lead.id)
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
      :tag_list,
      :outcome
    )
  end
end
