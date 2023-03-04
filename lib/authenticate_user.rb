class AuthenticateUser

  prepend SimpleCommand

  attr_accessor :email, :password

  def initialize(email, pwd)
    @email = email
    @password = pwd
  end

  def call
    user = get_user
    if user
      refresh_token = RefreshToken.generate(user_id: user.id)
      jwt = JsonWebToken.encode(user_id: user.id, role: user.role, refresh_token_id: refresh_token.id)
      return {
        body: {
          token: jwt,
          user_id: user.id,
          role: user.role
        },
        user_id: user.id,
        refresh_token: refresh_token.secret
      }
    end
  end

  protected

  def get_user
    User.transaction do
      success = false

      user = User.lock(true).find_by_email(email)



      if user.nil?
        errors.add :authentication, 'Email o password errati!'
        return nil
      end

      if user.blocked?
        if user.tmp_blocked?
          # TODO lato client chiedi tra quanto (o quando) è disponibile l'utente.
          errors.add :tmp_block, 'L\'account è temporaneamente bloccato!'
        else
          if user.banned?
            errors.add :user_ban, 'L\'account è stato bannato!'
          else
            if user.status == 'blocked'
              errors.add :user_block, 'L\'account è stato bloccato!'
            end
          end
        end
        return nil
      end

      if user.authenticate(password)
        success = true

        user.locked_at = nil
        user.failed_attempts = 0
        
        if user.deleted?
          errors.add :account_deleted, 'Questo account è cancellato!'
          return nil
        end

      else
        errors.add :authentication, 'Email o password errati!'
        user.failed_attempts += 1
        max_attempts = Rails.configuration.app[:fail_to_login_attempts] || 10
        if user.failed_attempts >= max_attempts
          errors.add :account_blocked, "Hai superato i 10 tentativi falliti, il tuo account sarà bloccato per #{Rails.configuration.app[:user_block_ttl]} secondi."
          user.tmp_block!
        end
      end

      user.save

      return success ? user : nil

    end
  end

end