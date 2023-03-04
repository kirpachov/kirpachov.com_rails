# frozen_string_literal: true

WITH_REAL_DATABASE = 'with real database'

require 'rake'

RSpec.shared_context WITH_REAL_DATABASE do
  def import_real_life_table(klass)
    table_name = klass.table_name
    base_path = 'spec/fixtures/real_life_sql/tables/'
    file_path = "#{base_path}/#{table_name}.sql"
    skip 'File with the database does not exist' unless File.exist?(file_path)

    puts "Importing table #{table_name} from file: #{file_path.inspect}"
    connection = klass.connection
    Timeout.timeout(10) do
      connection.execute("TRUNCATE TABLE #{table_name} CASCADE")
      sql = File.read(file_path)

      connection.execute(sql)

      connection.reset!
    end

    puts 'Database imported'
  end

  # def import_dbfile(dbfile_path)
  #   ActiveRecord::Base.transaction do
  #     # database_file = 'spec/fixtures/associate_customers_to_rfqs.sql'
  #     # Check if the file exists.
  #     # If the file does not exist, we will skip the test.
  #     # This is useful when we want to run the test in a CI.
  #     # In this case, we will not have the file with the database.
  #     # So, we will skip the test.
  #     skip 'File with the database does not exist' unless File.exist?(dbfile_path)

  #     # Import the database from the file.
  #     # ActiveRecord::Base.connection.execute(IO.read(database_file))

  #     status = Timeout.timeout(10) do
  #       Rails.logger.info "Importing database from file: #{dbfile_path.inspect}"
  #       ActiveRecord::Base.connection.execute(File.read(dbfile_path))
  #       Rails.logger.info 'Database imported'
  #     end
  #     byebug
  #   end
  # end
end
