class Admin::DecisionMakerCompaniesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @q = Contact.where(is_decision_maker: true).ransack(params[:q])

    @contacts = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "admin/decision_maker_companies/list_decision_maker_companies", formats: :html }
    end
  end
end
