# frozen_string_literal: true

# Base application mailer class.
class ApplicationMailer < ActionMailer::Base
  default from: Config.app.dig(:emails, :default_from),
          reply_to: Config.app.dig(:emails, :default_reply_to) || Config.app.dig(:emails, :default_from)

  layout 'mailer'
end
