class Admin::ProposalsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @leads = Lead.all
    @companies = Company.where(id: @leads.pluck(:company_id))
    @template_proposals = TemplateProposal.all


    puts "@companies: #{@companies.inspect}"
  end
end
