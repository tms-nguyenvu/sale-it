class Admin::PredictAbilityCompaniesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    threshold = 70
    @companies = Company.where("potential_score >= ?", threshold)

    if params[:search].present?
      @companies = @companies.search_full_text(params[:search])
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "admin/predict_ability_companies/index", formats: :html }
    end
  end
end
