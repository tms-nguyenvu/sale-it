module EmailService
  class EmailContentService
    attr_reader :contacts, :contact, :user

    def initialize(contacts, contact, user)
      @contacts = contacts
      @contact = contact
      @user = user
    end

    def generate_content(tone)
      return @contacts.map { |c| generate_email_content(c, tone) } if @contacts
      generate_email_content(@contact, tone)
    end

    private

    def generate_email_content(contact, tone)
      {
        subject: generate_subject(contact, tone),
        body: generate_body(contact, tone)
      }
    end

    def generate_subject(contact, tone)
      I18n.t(
        "email_content.subject.#{tone}",
        name: contact.name || "Valued Customer",
        default: I18n.t("email_content.subject.default", name: contact.name || "Valued Customer")
      )
    end

    def generate_body(contact, tone)
      [
        generate_greeting(contact, tone),
        generate_intro(contact, tone),
        generate_value_proposition(contact, tone),
        generate_cta(contact, tone),
        generate_signature(tone)
      ].join("\n\n")
    end

    def generate_greeting(contact, tone)
      I18n.t(
        "email_content.greeting.#{tone}",
        name: contact.name || "Valued Customer",
        default: I18n.t("email_content.greeting.default", name: contact.name || "Valued Customer")
      )
    end

    def generate_intro(contact, tone)
      job_details = format_job_details(contact.company.jobs.limit(3))
      I18n.t(
        "email_content.intro.#{tone}",
        company: contact.company.name || "Your Company",
        job_details: job_details,
        default: I18n.t("email_content.intro.default", company: contact.company.name || "Your Company", job_details: job_details)
      )
    end

    def generate_value_proposition(contact, tone)
      job_details = format_job_details(contact.company.jobs.limit(3))
      I18n.t(
        "email_content.value_proposition.#{tone}",
        company: contact.company.name || "Your Company",
        industry: contact.company.industry || "Technology",
        job_details: job_details,
        default: I18n.t("email_content.value_proposition.default", company: contact.company.name || "Your Company", industry: contact.company.industry || "Technology", job_details: job_details)
      )
    end

    def generate_cta(contact, tone)
      slug_name = (contact.name || "Valued Customer").to_s.parameterize
      target = "https://tomosia.com.vn/"
      tracking_url = "http://localhost:3000/email_trackings?contact_id=#{contact.id}&target=#{CGI.escape(target)}"

      vars = {
        company: contact.company.name || "Your Company",
        name: slug_name,
        url: tracking_url
      }

      I18n.t("email_content.cta.#{tone}", **vars, default: I18n.t("email_content.cta.default", **vars)).html_safe
    end

    def generate_signature(tone)
      I18n.t("email_content.signature.#{tone}", default: I18n.t("email_content.signature.default"))
    end

    def format_job_details(jobs)
      return "No open jobs found" if jobs.empty?
      jobs.map { |job| "#{job.title} (#{job.level}, #{job.tech_stack.join(", ")})" }.join("; ")
    end
  end
end
