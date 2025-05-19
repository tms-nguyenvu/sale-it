class Admin::ProposalsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @leads = Lead.all
    @companies = Company.where(id: @leads.pluck(:company_id))
    @template_proposals = TemplateProposal.all
    @proposals = Proposal.all
  end

  def create
    company_id = params.dig(:proposal, :company_id)
    lead = Lead.find_by(company_id: company_id)

    unless lead
      respond_to do |format|
        format.html do
          flash[:error] = "Could not find lead for this company"
          render :index
        end
        format.json { render json: { success: false, error: "Could not find lead for this company" }, status: :not_found }
      end
      return
    end

    @proposal = Proposal.new(
      lead_id: lead.id,
      template_proposal_id: params.dig(:proposal, :template_proposal_id),
      title: params.dig(:proposal, :title),
      requirement: params.dig(:proposal, :requirement),
      customized_proposal: params.dig(:proposal, :customized_proposal),
      status: "sent"
    )
    lead.update(status: "negotiate")
    GenerateLeadSuggestionJob.perform_later(lead.id)

    respond_to do |format|
      if @proposal.save
        format.html { redirect_to admin_proposals_path, notice: "Proposal was successfully created." }
        format.json { render json: { success: true, message: "Proposal was successfully created." } }
      else
        format.html do
          flash[:error] = @proposal.errors.full_messages.join(", ")
          render :index
        end
        format.json { render json: { success: false, errors: @proposal.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def proposal_params
    params.require(:proposal).permit(:company_id, :template_proposal_id, :title, :requirement, :customized_proposal)
  end
end
