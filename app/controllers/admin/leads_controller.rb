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

  private

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def lead_params
    params.require(:lead).permit(:status)
  end
end
