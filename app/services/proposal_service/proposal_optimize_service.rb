module ProposalService
  class ProposalOptimizeService
    def initialize(proposal)
      @proposal = proposal
    end

    def optimize_proposal
      prompt = I18n.t("ai.proposal.proposal_optimization_prompt", proposal: @proposal)
      raw = Gemini::GenerateContent.call(prompt: prompt)

      JSON.parse(raw, symbolize_names: true)
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse AI response: #{e.message}")
    end
  end
end
