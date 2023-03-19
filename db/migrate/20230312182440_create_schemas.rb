class CreateSchemas < ActiveRecord::Migration[7.0]
  def up
    %i[
      public
    ].each do |schema|
      execute "CREATE SCHEMA IF NOT EXISTS #{schema}"
    end
  end
end
