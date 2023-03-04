# frozen_string_literal: true

# Base class for all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # ############################
  # Settings and constants
  # ############################
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  RAILS_INT_MAX_VAL = 2_147_483_647

  # ############################
  # Scopes
  # ############################
  scope :visible, -> { all }
  scope :random_order, -> { order('RANDOM()') }

  # ############################
  # Class methods
  # ############################
  class << self
    def next_id
      all.order(:id).last.id.to_i + 1
    end

    def table_info(args = {})
      TableInfo.call(self, args)
    end

    def log_table_info(args = {})
      puts table_info(args).process
    end

    # def notify_changes
    #   ChangesChannel.notify_item_reload(self)
    #   ChangesChannel.notify_to_list_pages(self)
    # end
  end

  # ############################
  # Instance methods
  # ############################
  def log_info(data = as_json)
    return super if defined?(super)

    puts Text::Table.new(
      head: data.keys,
      rows: [data.values]
    ).to_s
  end
end
