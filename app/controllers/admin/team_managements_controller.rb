class Admin::TeamManagementsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @users = User.all
    @new_leads = Lead.where(status: "new_lead")
    @leads = Lead.all

    # Team overall performance
    successful_leads = Lead.where(outcome: "won").count
    total_completed_leads = Lead.where(outcome: [ "won", "lost" ]).count

    @conversion_rate = if total_completed_leads.positive?
                         (successful_leads.to_f / total_completed_leads * 100).round(2)
    else
                        0
    end

    # Current user performance
    @active_leads = Lead.where(manager_id: current_user.id, outcome: nil).count
    @won_deals = Lead.where(manager_id: current_user.id, outcome: "won").count
    @total_leads = Lead.where(manager_id: current_user.id).count
    @personal_conversion = if @total_leads.positive?
                            (@won_deals.to_f / @total_leads * 100).round(2)
    else
                            0
    end

    # Team members performance
    @team_performance = @users.map do |user|
      active = Lead.where(manager_id: user.id).count
      puts "active: #{active}"
      won = Lead.where(manager_id: user.id, outcome: "won").count
      total = Lead.where(manager_id: user.id).count
      conversion = total.positive? ? (won.to_f / total * 100).round(2) : 0

      {
        user: user,
        active_leads: active,
        won_deals: won,
        total_leads: total,
        conversion_rate: conversion
      }
    end

    # Recent activities for current user
    @my_recent_leads = Lead.where(manager_id: current_user.id)
                          .order(updated_at: :desc)
                          .limit(5)
  end
end
