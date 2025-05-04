class Admin::DecisionMakerCompaniesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @contacts = Contact.where(is_decision_maker: true)

    if params[:search].present?
      @contacts = @contacts.search_full_text(params[:search])
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "admin/decision_maker_companies/list_decision_maker_companies", formats: :html }
    end
  end
end
