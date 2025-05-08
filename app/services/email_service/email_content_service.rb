module EmailService
  class EmailContentService
    attr_reader :contacts, :contact, :user

    def initialize(contacts, contact, user)
      @contacts = contacts
      @contact = contact
      @user = user
    end

    def generate_content(tone)
      return @contacts.map { |contact| generate_email_content(contact, tone) } if @contacts
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
      I18n.t("email_content.subject.#{tone}", name: contact.name, default: I18n.t("email_content.subject.default",
      name: contact.name))
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
      I18n.t("email_content.greeting.#{tone}", name: contact.name, default: I18n.t("email_content.greeting.default",
      name: contact.name))
    end

    def generate_intro(contact, tone)
      I18n.t("email_content.intro.#{tone}", company: contact.company.name, default: I18n.t("email_content.intro.default",
      company: contact.company.name))
    end

    def generate_value_proposition(contact, tone)
      I18n.t("email_content.value_proposition.#{tone}", company: contact.company.name, industry: contact.company.industry,
      default: I18n.t("email_content.value_proposition.default", company: contact.company.name, industry: contact.company.industry))
    end

    def generate_cta(contact, tone)
      I18n.t("email_content.cta.#{tone}", company: contact.company.name, default: I18n.t("email_content.cta.default",
      company: contact.company.name))
    end

    def generate_signature(tone)
      I18n.t("email_content.signature.#{tone}", default: I18n.t("email_content.signature.default"))
    end
  end
end
