class ContactMailer < ApplicationMailer
  def outreach_email(body, subject)
    @content = body
    mail(
      to: "vu.nguyen1.tms@gmail.com", # test send email
      subject: subject,
    )
  end
end
