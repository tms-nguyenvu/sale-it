class Admin::DashboardController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    def index
        @proposals = Proposal.order(created_at: :desc).limit(5)
        @leads = Lead.order(created_at: :desc).limit(5)
        @emails = Email.order(sent_at: :desc).limit(5)


        @lead_stats = Lead.group(:status).count
        @email_stats = Email.group(:status).count
        @proposal_stats = Proposal.group(:status).count
        @companies_by_industry = Company.group(:industry).count

        @total_leads = Lead.count
        @total_proposals = Proposal.count
        @total_companies = Company.count
        @total_sent_emails = Email.where(status: :sent).count
    end
end
