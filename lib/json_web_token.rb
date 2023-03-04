class JsonWebToken
  def self.encode(payload, exp = 15.minutes.from_now)
    payload[:exp] = exp.to_i
    payload[:ttl] = exp.to_i - Time.now.to_i
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
  end
end