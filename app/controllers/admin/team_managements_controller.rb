class Admin::TeamManagementsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @users = User.all
    @new_leads = Lead.where(status: "new_lead")
    @leads = Lead.all

    successful_leads = Lead.where(outcome: "won").count
    total_completed_leads = Lead.where(outcome: [ "won", "lost" ]).count

    @conversion_rate = if total_completed_leads.positive?
                         (successful_leads.to_f / total_completed_leads * 100).round(2)
    else
                        0
    end
  end
end
