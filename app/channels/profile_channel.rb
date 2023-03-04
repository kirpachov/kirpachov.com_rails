# frozen_string_literal: true

# Implements the logic for profile data websocket channel
class ProfileChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end
end
