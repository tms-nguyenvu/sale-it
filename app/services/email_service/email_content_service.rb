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
      case tone
      when "friendly" then "Hey #{contact.name}, a quick note from TOMOSIA here."
      when "casual" then "#{contact.name}, check this out!"
      when "formal" then "Business Opportunity for #{contact.name}"
      when "professional" then "Introducing a tailored solution for #{contact.name}"
      else "Introducing a tailored solution for #{contact.name}"
      end
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
      case tone
      when "friendly" then "Hi #{contact.name},"
      when "casual" then "Hey #{contact.name},"
      when "formal" then "Dear #{contact.name},"
      when "professional" then "Hello #{contact.name},"
      else "Hello #{contact.name},"
      end
    end

    def generate_intro(contact, tone)
      case tone
      when "friendly" then "Hope you're doing great! Just wanted to share something that might be helpful for #{contact.company.name}."
      when "casual" then "Yo! Quick note about something cool we're working on — might be useful for #{contact.company.name}."
      when "formal" then "I am writing to formally introduce our services and how they may align with the goals of #{contact.company.name}."
      when "professional" then "I wanted to reach out regarding our solutions that can streamline operations at #{contact.company.name}."
      else "I wanted to reach out regarding campaigns. We believe our solutions can benefit #{contact.company.name}."
      end
    end

    def generate_value_proposition(contact, tone)
      case tone
      when "friendly" then "We've built a tool that makes things easier for teams like yours — saving time, boosting results, and eliminating those annoying manual tasks that slow everyone down."
      when "casual" then "Basically, it's a no-hassle way to get stuff done faster without breaking a sweat. Our clients in #{contact.company.industry} are seeing some pretty sweet results."
      when "formal" then "Our solutions are specifically designed to support organizations within the #{contact.company.industry} industry in achieving operational excellence and cost efficiency. Our proprietary methodology has demonstrated substantial ROI for enterprises similar to #{contact.company.name}."
      when "professional" then "Our product helps companies like yours in the #{contact.company.industry} industry to improve efficiency by 30% and reduce costs by up to 25%. We've worked with similar companies and understand the unique challenges you face."
      else "Our product helps companies like yours in the #{contact.company.industry} industry to improve efficiency and reduce costs."
      end
    end

    def generate_cta(contact, tone)
      case tone
      when "friendly" then "Want to hop on a quick call this week to chat about how this could work for your team? I'm free most afternoons."
      when "casual" then "Wanna catch up sometime soon? I can show you how this works in about 15 minutes."
      when "formal" then "Please advise a convenient time for a brief discussion at your earliest availability. I would be pleased to provide a comprehensive overview of our solutions and their potential application to #{contact.company.name}'s objectives."
      when "professional" then "Let me know a suitable time to discuss further. I'd be happy to schedule a brief demo showing how our solutions can address your specific needs."
      else "Let me know a suitable time to discuss further."
      end
    end

    def generate_signature(tone)
      case tone
      when "friendly" then "Cheers,\n(Your Name)"
      when "casual" then "Thanks!\n(Your Name)"
      when "formal" then "Sincerely,\n(Your Name)"
      when "professional" then "Best regards,\n(Your Name)"
      else "Regards,\n(Your Name)"
      end
    end
  end
end
