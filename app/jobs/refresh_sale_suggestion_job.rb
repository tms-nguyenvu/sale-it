class RefreshSaleSuggestionJob < ApplicationJob
  queue_as :default

  def perform(*args)
    leads = Lead.all

    leads.each do |lead|
      leads.update_all(suggestions: nil)
      GenerateLeadSuggestionJob.perform_later(lead.id)
    end
  end
end
