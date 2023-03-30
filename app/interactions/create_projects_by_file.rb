# frozen_string_literal: true

class CreateProjectsByFile < ActiveInteraction::Base
  string :filename
  boolean :cleanup, default: false

  def execute
    Project.delete_all if cleanup

    path = Rails.root.join('data', filename).to_s
    file = Roo::Spreadsheet.open(path)
    sheet = file.sheet(0)
    data = sheet.parse(headers: true)[1..]
    byebug

    data.each do |row|
      proj = Project.new(row.as_json(only: Project.column_names).merge(production_urls: row['production_urls'].split(',')))
      proj.attributes = {
        title: row.delete('title_it'),
        description: row.delete('description_it'),
        locale: :it
      }

      proj.attributes = {
        title: row.delete('title_en'),
        description: row.delete('description_en'),
        locale: :en
      }

      unless row.empty?
        puts "WARNING: #{row.keys} not used"
      end

      proj.save!
    end
  end
end
