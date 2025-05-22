class Admin::PotentialCompaniesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @q = Company.where.not(
      name: nil,
      industry: nil,
      website: nil,
      crawl_source_id: nil,
      employee_count: nil,
      hiring_roles_count: nil,
      funding_round: nil,
      potential_score: nil
    ).includes(:jobs, :contacts, :leads).ransack(params[:q])

    result = @q.result(distinct: true)
    @pagy, @companies = pagy(result, limit: 9)

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "admin/potential_companies/list_potential_companies", formats: :html }
    end
  end
end
