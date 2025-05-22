class ApproveSingleCrawlSourceJob < ApplicationJob
  queue_as :default

  def perform(temp_id)
    temp = CrawlDataTemporary.find_by(id: temp_id)
    return unless temp

    data = temp.data || {}
    company_data = data["company"]
    contact_data = data["contact"]
    score_lead_data = data["score_lead"]
    jobs_data = data["jobs"]

    Rails.logger.info "Processing company_data: #{company_data.inspect}"

    name = company_data&.dig("name").to_s.strip
    return if name.blank?

    normalized_name = normalize_company_name(name)
    existing_company_names = Company.pluck(:name).map { |n| normalize_company_name(n) }.to_set
    return if existing_company_names.include?(normalized_name)

    company = Company.create!(
      name: name,
      industry: company_data["industry"],
      website: company_data["website"],
      funding_round: company_data["funding_round"],
      employee_count: company_data["employee_count"],
      hiring_roles_count: company_data["hiring_roles_count"],
      potential_score: score_lead_data&.dig("potential_score"),
      note: score_lead_data&.dig("note"),
      crawl_source_id: temp.crawl_source_id
    )

    if contact_data.present?
      company.contacts.create!(
        name: contact_data["name"],
        email: contact_data["email"],
        position: contact_data["position"],
        phone_number: contact_data["phone_number"],
        is_decision_maker: contact_data["is_decision_maker"]
      )
    end

    if jobs_data.present? && jobs_data["listings"].is_a?(Array)
      jobs_data["listings"].each do |job|
        company.jobs.create!(
          title: job["title"],
          level: job["level"],
          location: job["location"],
          tech_stack: Array(job["tech_stack"]).reject { |t| t == "Not specified" }.compact,
          posted_date: job["posted_date"],
          application_url: job["application_url"],
          employment_type: job["employment_type"]
        )
      end
    end
  end

  private

  def normalize_company_name(name)
    name.to_s.downcase
        .gsub(/[^a-z0-9]/, "")
        .squeeze(" ")
        .strip
  end
end
