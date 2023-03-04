# frozen_string_literal: true

module ApplicationCable
  # Implements the logic for new incomming WS connections and their authentication
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      authentication = AuthorizeApiRequest.call(request.headers, token: request.params[:token])
      return reject_unauthorized_connection unless authentication.success?

      self.current_user = authentication.result
      logger.add_tags 'ActionCable', current_user.id
    end
  end
end
