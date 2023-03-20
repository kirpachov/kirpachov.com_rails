# frozen_string_literal: true

# Mailer for public pages.
class PublicMailer < ApplicationMailer
  # TODO
  # add attachments

  # test this by console with
  # reload!; PublicMailer.with(sender_email: "sasha@opinioni.net", message: "ciao da sasha@opinioni.net").contact.deliver_now
  def contact
    @sender_email = params.delete(:sender_email)
    @name =         params.delete(:name) || @sender_email
    @message =      params.delete(:message)
    @subject =      params.delete(:subject) || "Contact from #{@name}"

    # @from = Config.app.dig(:emails, :default_from)
    @to = Config.app[:contact_emails]

    mail(
      # from: @from,
      reply_to: @sender_email,
      subject: "[kirpachov.com contact] #{@subject}",
      to: @to
    )
  end
end
