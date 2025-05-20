class Admin::DashboardController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    def index
        @proposals = Proposal.order(created_at: :desc).limit(5)
        @leads = Lead.order(created_at: :desc).limit(5)
        @emails = Email.order(sent_at: :desc).limit(5)
        @companies = Company.order(created_at: :desc).limit(5)
        @contacts = Contact.order(created_at: :desc).limit(5)
    end
end
