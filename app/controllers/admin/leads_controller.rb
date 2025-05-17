class Admin::LeadsController < ApplicationController
  before_action :set_lead, only: [ :update ]

  def index
    @leads = Lead.all
  end

  def update
    if @lead.update(lead_params)
      GenerateLeadSuggestionJob.perform_later(@lead.id)
      render json: { status: "success", message: "Lead updated successfully", lead: @lead }
    else
      render json: { status: "error", message: "Unable to update lead" }, status: :unprocessable_entity
    end
  end

  def create
    contact = Contact.find_by(company_id: params[:company_id])
    unless contact
      redirect_to admin_potential_companies_path, alert: "No contact found for this company."
      return
    end

    if Lead.exists?(company_id: contact.company_id) || Lead.exists?(contact_id: contact.id)
      redirect_to admin_potential_companies_path, alert: "Lead already exists for this company or contact."
      return
    end

    lead = Lead.new(
      contact_id: contact.id,
      company_id: contact.company_id,
      status: "new_lead"
    )
    if lead.save
      GenerateLeadSuggestionJob.perform_later(lead.id)
      redirect_to admin_potential_companies_path, notice: "Lead added to pipeline."
    else
      redirect_to admin_potential_companies_path, alert: "Failed to create lead."
    end
  end

  private

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def lead_params
    params.require(:lead).permit(:status)
  end
end
