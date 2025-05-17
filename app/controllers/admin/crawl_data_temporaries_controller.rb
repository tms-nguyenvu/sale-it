class Admin::CrawlDataTemporariesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_temp, only: [ :update ]

  def update
    if @temp.update(data_status: params[:action_type])
      if params[:action_type] == "approved"
        ApproveSingleCrawlSourceJob.perform_later(@temp.id)
        flash[:notice] = "Approval is being processed in the background."
      else
        flash[:notice] = "#{params[:action_type].capitalize} is being processed in the background."
      end
    else
      flash[:alert] = "Failed to #{params[:action_type]} data."
    end
    redirect_back fallback_location: admin_list_sources_path
  end

  private

  def set_temp
    @temp = CrawlDataTemporary.find(params[:id])
  end
end
