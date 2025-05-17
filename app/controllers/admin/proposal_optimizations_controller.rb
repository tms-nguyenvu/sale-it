class Admin::ProposalOptimizationsController < ApplicationController
  def create
    proposal_params = params[:proposal]
    raw_sections = proposal_params[:template_sections]
    parsed_sections = JSON.parse(raw_sections.first) rescue []
    proposal = {
      company_name: proposal_params[:company_name],
      title: proposal_params[:title],
      template_sections: parsed_sections,
      requirements: proposal_params[:requirements],
      sections: proposal_params[:sections]
    }

    optimized_proposal = ProposalService::ProposalOptimizeService.new(proposal).optimize_proposal

    if optimized_proposal
      @optimized_proposal = optimized_proposal
      render json: {
        success: true,
        flash: { type: "success", message: "Optimized proposal generated successfully" },
        optimized_proposal: optimized_proposal
      }
    else
      render json: {
        success: false,
        flash: { type: "error", message: "Error generating optimized proposal" }
      }
    end
  end
end
