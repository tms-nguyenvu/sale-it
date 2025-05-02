class ApproveCrawlSourceJob < ApplicationJob
  queue_as :default

  def perform(crawl_source_id)
    crawl_source = CrawlSource.find(crawl_source_id)

    crawl_source.update!(approval_status: :approved)

    existing_company_names = Company.pluck(:name).map { |n| normalize_company_name(n) }.to_set

    crawl_source.crawl_data_temporaries.find_each do |temp_data|
      data = temp_data.data || {}
      company_data = data["company"]
      contact_data = data["contact"]

      puts "data: #{data.inspect}"
      name = company_data["name"].to_s.strip
      next if name.blank?

      normalized_name = normalize_company_name(name)
      next if existing_company_names.include?(normalized_name)

      begin
        company = Company.create!(
          name: name,
          industry: company_data["industry"],
          website: company_data["website"],
          funding_round: company_data["funding_round"],
          employee_count: company_data["employee_count"],
          hiring_roles_count: company_data["hiring_roles_count"],
          crawl_source_id: crawl_source.id
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

        existing_company_names.add(normalized_name)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.warn "Skipped company #{name}: #{e.message}"
      end
    end
    crawl_source.crawl_data_temporaries.delete_all
  end

  private

  def normalize_company_name(name)
    name.to_s.downcase
        .gsub(/[^a-z0-9]/, "")
        .squeeze(" ")
        .strip
  end
end
