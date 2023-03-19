# frozen_string_literal: true

class CreateCommonProjectTranslations < ActiveRecord::Migration[7.0]
  def up
    Project.create_translation_table! title: :text, description: :text
  end

  def down
    Project.drop_translation_table!
  end
end
