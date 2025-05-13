class Admin::ContactsController < ApplicationController
  before_action :set_company

  def index
    @contacts = @company.contacts
    render json: @contacts
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end
