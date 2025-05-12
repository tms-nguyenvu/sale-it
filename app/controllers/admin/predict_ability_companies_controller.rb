class Admin::PredictAbilityCompaniesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    threshold = 70
    @q = Company.where("potential_score >= ?", threshold).ransack(params[:q])

    @companies = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "admin/predict_ability_companies/index", formats: :html }
    end
  end
end
