class Admin::PotentialCompaniesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @companies = Company.where.not(name: nil)
                        .where.not(industry: nil)
                        .where.not(website: nil)
                        .where.not(crawl_source_id: nil)
                        .where.not(employee_count: nil)
                        .where.not(hiring_roles_count: nil)
                        .where.not(funding_round: nil)
                        .where.not(potential_score: nil)

    if params[:search].present?
      @companies = @companies.search_full_text(params[:search])
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "admin/potential_companies/list_potential_companies", formats: :html }
    end
  end
end
