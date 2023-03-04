# frozen_string_literal: true

class AuthorizeApiRequest
  prepend SimpleCommand

  attr_reader :headers, :refresh_token

  def initialize(headers = {}, token: nil)
    @headers = headers
    @token = token
  end

  def call
    authenticate_and_get_user
  end

  private

  # Check JWT token and get user to whom JWT token belongs.
  def authenticate_and_get_user
    # Return nil if JWT token is invalid
    if jwt_payload.nil?
      errors.add(:token, 'Identificativo di accesso non valido!')
      return nil
    end

    # Find refresh token which has been used for JWT token generation
    @refresh_token = RefreshToken.not_expired.where(id: jwt_payload[:refresh_token_id]).first

    catch :failed do
      check_refresh_token!(@refresh_token)
      @user = fetch_refresh_token_user(@refresh_token)
      check_if_user_blocked!(@user)

      return @user
    end

    nil
  end

  # Decode JWT token data
  def jwt_payload
    @jwt_payload ||= JsonWebToken.decode(find_token)
  end

  # Find token from :token parameter, or search in Authorization headers
  def find_token
    return @token unless @token.blank?
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    errors.add(:token, 'Sessione non valida o scaduta!')
    nil
  end

  # Check if refresh token exists
  def check_refresh_token!(refresh_token)
    return if refresh_token

    errors.add(:token, 'Sessione non valida o scaduta!')
    throw :failed
  end

  # Fetch user associated to refresh token or throw :failed
  def fetch_refresh_token_user(refresh_token)
    user = refresh_token.user
    return user if user

    errors.add(:user_not_found, 'Utente non trovato!')
    throw :failed
  end

  # Check if user is blocked and throw :failed if so
  def check_if_user_blocked!(user)
    return unless user.blocked?

    errors.add :temporarily_blocked, "L'account è temporaneamente bloccato!" if user.temporarily_blocked?
    errors.add :user_banned, "L'account è stato bannato!" if user.banned?
    errors.add :user_deleted, 'Questo account è cancellato!' if user.deleted?

    throw :failed
  end
end
