# frozen_string_literal: true

require 'csv'

# Array of hashes to CSV
# Example:
# ArrayToCsv.call([{id: 1, surname: "surname"}, {id: 2, name: "name"}]).file
class ArrayToCsv
  prepend SimpleCommand

  attr_reader :errors, :data

  # params[:filename] - filename for the generated file
  def initialize(array_of_hashes, params = {})
    @data = array_of_hashes
    @errors = ActiveModel::Errors.new(self)
    @filename = params[:filename] || "#{self.class.name}-#{Time.now.to_i}.csv"
  end

  def call
    validate
    return false if invalid?

    file
  end

  def validate
    validate_inputs
    errors.empty?
  end

  def valid?
    validate
  end

  def invalid?
    !valid?
  end

  def raw
    file.read
  end

  def file
    @file ||= generate_file
  end

  private

  def validate_inputs
    errors.add(:array, 'Must be an array') unless data.is_a?(Array)
    errors.add(:array, 'Must not be empty') if data.empty?
    errors.add(:array, 'Must be an array of hashes') unless data.all? { |e| e.is_a?(Hash) }
  end

  def generate_file
    @file = Tempfile.new(@filename)
    CSV.open(@file.path, 'w') do |csv|
      headers = data.flat_map(&:keys).uniq
      csv << headers
      data.each do |row|
        csv << row.values_at(*headers)
      end
    end

    @file.rewind
    @file
  end
end
