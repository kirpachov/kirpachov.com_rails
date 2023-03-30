# frozen_string_literal: true

class AddInitialProjects < ActiveRecord::Migration[7.0]
  def up
    CreateProjectsByFile.run!(filename: 'projects.xlsx', cleanup: true)
  end

  def down
    throw ActiveRecord::IrreversibleMigration
  end
end
