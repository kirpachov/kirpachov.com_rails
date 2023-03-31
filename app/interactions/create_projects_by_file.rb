# frozen_string_literal: true

class CreateProjectsByFile < ActiveInteraction::Base
  string :filename, default: 'projects.xlsx'
  boolean :cleanup, default: true

  def execute
    Project.delete_all if cleanup

    path = Rails.root.join('data', filename).to_s
    file = Roo::Spreadsheet.open(path)
    sheet = file.sheet(0)
    data = sheet.parse(headers: true)[1..]

    data.each do |row|
      proj = Project.new(production_urls: row.delete('production_urls').split(',') || [])
      %w[status start_date end_date visibility].each { |col| proj[col] = row.delete(col) }
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
