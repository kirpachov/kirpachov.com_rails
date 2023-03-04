# frozen_string_literal: true

module ActiveModel
  # Opening ActiveModel::Errors to add a function
  class Errors
    def full_json(*args)
      errors.map { |er| er.full_json(*args) }
    end
  end
end
