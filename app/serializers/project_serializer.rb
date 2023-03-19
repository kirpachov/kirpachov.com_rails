# frozen_string_literal: true

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :status, :title, :description, :visibility
end
