class Admin::ProposalTemplatesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_proposal_template, only: [ :update, :destroy ]

  def index
    @proposal_templates = TemplateProposal.all
  end

  def new
    @proposal_template = TemplateProposal.new
  end

  def create
    @proposal_template = TemplateProposal.new(proposal_template_params)

    if @proposal_template.save
      redirect_to admin_proposal_templates_path, notice: "Template created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @proposal_template.update(proposal_template_params)
      redirect_to admin_proposal_templates_path, notice: "Template updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @proposal_template.destroy
    redirect_to admin_proposal_templates_path, notice: "Template deleted successfully."
  end

  private

  def set_proposal_template
    @proposal_template = TemplateProposal.find(params[:id])
  end

  def proposal_template_params
    params.require(:proposal_template).permit(
      :name,
      :description,
      template_sections_attributes: [ :id, :title, :content, :_destroy ]
    )
  end
end
