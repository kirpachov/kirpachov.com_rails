class RefreshJwtToken
  prepend SimpleCommand

  def initialize(refresh_token_secret)
    @refresh_token_secret = refresh_token_secret
  end

  def call
    result = refresh_token(@refresh_token_secret)
    if result
      {
        body: {
          token: result[:jwt]
        },
        new_refresh_token: result[:new_secret]
      }
    end
  end

  private

  def refresh_token(secret)
    result = nil
    if secret.blank?
      errors.add :missing_refresh_token, 'Refresh token is missing'
    else
      RefreshToken.transaction do
        refresh_token = RefreshToken.where(expired: false).lock(true).find_by_secret(secret)
        if refresh_token
          user = refresh_token.user

          if user.nil?
            errors.add(:user_not_found, "User not found")
            raise ActiveRecord::Rollback
          end

          # jwt = JsonWebToken.encode(User.find(user.id).as_json)
          jwt = JsonWebToken.encode(user_id: user.id, role: user.role, refresh_token_id: refresh_token.id)
          refresh_token.secret = SecureRandom.urlsafe_base64(32)
          if refresh_token.save
            result = { jwt: jwt, new_secret: refresh_token.secret }
          else
            errors.add :failed_to_refresh_token, refresh_token.errors.full_messages[0]
          end
        else
          errors.add :invalid_refresh_token, 'Invalid refresh token'
        end
      end
    end

    return result
  end
end