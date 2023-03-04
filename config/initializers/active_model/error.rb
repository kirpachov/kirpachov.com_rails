# frozen_string_literal: true

module ActiveModel
  # Opening ActiveModel::Error to add a function
  class Error
    # This will return a custom error message will all the necessary details.
    # To exclude fields: errors.full_json(options: {except: ["attribute"]})
    def full_json(options: {})
      options[:except] ||= []
      options[:except] << 'base'

      to_merge = { message: message }
      to_merge[:details] = recursive_details if options[:recursive_details] && options[:details]
      as_json(options).merge(to_merge).with_indifferent_access
    end

    def recursive_details
      options[:details].filter { |er| er.is_a?(ActiveModel::Errors) }.map do |errors|
        errors.full_json(options: options)
      end
    end
  end
end
