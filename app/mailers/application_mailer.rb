# frozen_string_literal: true

# Base application mailer class.
class ApplicationMailer < ActionMailer::Base
  default from: Config.app[:emails][:default_from],
          reply_to: Config.app[:emails][:default_reply_to] || Config.app[:emails][:default_from]

  layout 'mailer'
end
