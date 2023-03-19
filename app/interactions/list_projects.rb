# frozen_string_literal: true

class ListProjects < ActiveInteraction::Base
  boolean :public_only, default: false
  object :filters, class: Hash, default: {}
  # object :current_user, class: User, default: nil

  def items
    Project.where.not(status: :deleted).includes(:translations)
  end

  def public_items(items)
    items.where(visibility: :public)
  end

  def visible
    return public_items(items) if public_only

    items
  end

  def execute
    items = visible
    items.where!(filters) if filters.present?
    items
  end
end
