# frozen_string_literal: true

# A Project is a work that is done for a client.
class Project < ApplicationRecord
  # ##############################
  # Settings
  # ##############################
  translates :title, :description

  enum status: {
    'pending' => 'pending',
    'wip' => 'wip',
    'done' => 'done',
    'canceled' => 'canceled',
    'deleted' => 'deleted'
  }

  VISIBILITY_OPTIONS = %w[public internal].freeze

  # ##############################
  # Validations
  # ##############################
  # validates :status, presence: true, inclusion: { in: Project.statuses.keys }
  validates :start_date, presence: true, if: :wip?
  validates :end_date, presence: true, if: :done?
  # validates :start_date, presence: true, if: -> { end_date.present? }
  validates :visibility, presence: true, inclusion: { in: VISIBILITY_OPTIONS }

  # ##############################
  # HOOKS
  # ##############################
  before_validation :set_defaults

  # ##############################
  # Instance methods
  # ##############################
  def set_defaults
    self.status ||= 'pending'
    self.production_urls = production_urls.reject(&:blank?) if production_urls.is_a?(Array)
    self.visibility ||= :internal
  end

  def start!
    self.start_date = Date.today
    self.status = 'wip' if self.status == 'pending'
    save!
  end

  def end!
    self.end_date = Date.today
    self.status = 'done' if self.status == 'wip'
    save!
  end
end
