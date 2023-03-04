# frozen_string_literal: true

# Mailer to notify developers about things.
class DevelopersMailer < ApplicationMailer
  def simple_message(args = {})
    return unless can_send?

    args = params if params.present?
    @subject = args[:subject] || args[:text] || "Notifica per sviluppatori da Quotations #{Rails.env}"
    @text = args[:text] || 'Questa email è vuota'

    @subject = "(#{Config.app[:name].downcase}_dev_#{Rails.env.downcase}) #{@subject}"

    mail(
      to: emails,
      subject: @subject
    )
  end

  private

  def can_send?
    emails.present? && Config.app[:send_developers_emails] == true
  end

  def emails
    Config.app[:developers_emails]
  end
end
