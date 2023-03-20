# frozen_string_literal: true

# Send email to the site owner.
class ContactMe < ActiveInteraction::Base
  string :name, :email, :message

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :message, :email, presence: true

  def execute
    PublicMailer.with(
      sender_email: email,
      name: name,
      message: message,
    ).contact.deliver_now
  end
end
