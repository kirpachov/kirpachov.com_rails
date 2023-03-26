# frozen_string_literal: true

class FindProject < ActiveInteraction::Base
  boolean :public_only, default: false
  object :filters, class: Hash, default: {}
  integer :id, null: false

  def items
    ListProjects.run!(filters: filters, public_only: public_only)
  end

  def filter_by_id(items)
    items.find(id)
  end

  def execute
    filter_by_id(items)
  end
end
