# frozen_string_literal: true

# This task will extract data from the current database and save it to files, a file for each table.
# This is used to create real-life examples for the tests.
# The files are saved in the folder 'spec/fixtures/real_life_sql'.
# The files are not in the repository.
# To run this task, use the command:
#   $ bundle exec rake db:extract_fixtures
namespace :db do
  task :prepare_fixtures do
    dbname = Rails.configuration.database_configuration[Rails.env]['database']
    output_folder = 'spec/fixtures/real_life_sql/tables/'

    # Create the folder 'spec/fixtures' if it does not exist.
    FileUtils.mkdir_p output_folder

    command_template = 'pg_dump --table %s --column-inserts --data-only %s > "%s"'

    puts %(Executing #{command_template.inspect})
    # For each table, extract the data to a file.
    ActiveRecord::Base.connection.tables.each do |table|
      output_file = Rails.root.join(output_folder, "#{table}.sql").to_s

      system command_template % [table, dbname, output_file]
      puts %(Table #{table.inspect} exported to #{output_file.inspect})
    end
  end
end
