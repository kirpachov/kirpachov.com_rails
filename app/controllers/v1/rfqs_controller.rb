# frozen_string_literal: true

module V1
  # Request for quote controller.
  class RfqsController < ApplicationController
    skip_before_action :authenticate_user, only: %i[contact]

    def contact
      result = ContactMe.run(contact_params)

      render json: {
        success: result.valid?,
        errors: result.errors.full_json,
        message: result.valid? ? 'Your message has been sent.' : 'There was an error sending your message.'
      }, status: result.valid? ? :ok : :unprocessable_entity
    end

    private

    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
  end
end
