# frozen_string_literal: true

return unless Rails.env.development? || Rails.env.test?

# Module that manages translations.
module I18n
  def self.exception_raiser(*args)
    exception, locale, key, options = args
    raise "i18n #{exception}"
  end
end

I18n.exception_handler = :exception_raiser
