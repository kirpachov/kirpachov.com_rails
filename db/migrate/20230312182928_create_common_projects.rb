# frozen_string_literal: true

class CreateCommonProjects < ActiveRecord::Migration[7.0]
  def change
    create_table 'projects' do |t|
      t.text :status
      t.date :start_date
      t.date :end_date
      t.text :production_urls, array: true, default: []
      t.text :visibility, null: false

      t.timestamps
    end
  end
end
