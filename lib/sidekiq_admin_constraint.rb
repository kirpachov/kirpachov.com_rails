# frozen_string_literal: true

class SidekiqAdminConstraint
  def self.matches?(request)
    cookies = ActionDispatch::Cookies::CookieJar.build(request, request.cookies)
    return false unless cookies.encrypted[:refresh_token].present?

    user = RefreshToken.where(secret: cookies.encrypted[:refresh_token]).first&.user
    user&.present?
  end
end
