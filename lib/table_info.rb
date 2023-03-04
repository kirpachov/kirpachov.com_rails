# frozen_string_literal: true

# This class will log the requested ActiveRecord table data.
class TableInfo
  class << self
    def call(*args)
      new(*args).call
    end
  end

  # TODO
  # add yaml
  # add xml
  # add csv
  # add json

  # "log" => returs string with the requested columns
  PERMITTED_OUTPUT_FORMAT = %i[log].freeze
  DEFAULT_COLUMNS_TO_DISPLAY = %w[name null default type sql_type default_function].freeze

  # prepend SimpleCommand

  attr_accessor :model, :output_format, :columns, :errors, :warnings

  def initialize(model, args = {})
    @errors = SimpleCommand::Errors.new
    @warnings = SimpleCommand::Errors.new
    parse_args(args.merge(model: model))

    validate
  end

  def call
    return self if invalid?

    prepare

    self
  end

  def prepare
    map_columns
  end

  def process
    # return @table_info = @columns.as_json if output_format == :json
    return log_table_info if output_format == :log
  end

  def validate
    @errors.add(:model, "param 'model' is required.") if model.nil?

    unless model.ancestors.include?(ActiveRecord::Base)
      @errors.add(:model, "Param 'model' must be a ActiveRecord::Base descendant.")
    end

    unless @columns_to_display.nil? || @columns_to_display.is_a?(Array)
      @errors.add(:columns_to_display, "Param 'columns_to_display' must be an Array (or nil).")
    end

    return if PERMITTED_OUTPUT_FORMAT.include?(output_format.to_sym)

    @errors.add(:output_format, "Param 'output_format' not in #{PERMITTED_OUTPUT_FORMAT.inspect}")
  end

  def valid?
    validate

    errors.empty?
  end

  def invalid?
    !valid?
  end

  def log_table_info
    columns_to_display = @columns_to_display || DEFAULT_COLUMNS_TO_DISPLAY || @columns.first.as_json.keys

    Text::Table.new(
      head: columns_to_display,
      rows: @columns.map { |c| columns_to_display.map { |key| c[key] } }
    ).to_s
  end

  # @param "format" => 'string' | 'symbol'
  def column_names(format: 'string')
    @columns.map do |c|
      format == 'string' ? c[:name].to_s : c[:name].to_sym
    end
  end

  private

  def parse_args(args)
    raise ArgumentError, 'Args must be hash' unless args.is_a?(Hash)

    @model = args.delete(:model)
    @output_format = args.delete(:output_format)&.to_sym || :log
    @columns_to_display = args.delete(:columns_to_display)

    @columns_to_display = DEFAULT_COLUMNS_TO_DISPLAY if @columns_to_display.is_a?(Array) && @columns_to_display.empty?

    args.each do |k, v|
      msg = %(
        #{self.class}.#{__method__} - #{__FILE__}:#{__LINE__}
        Unknown arg: #{k.inspect} with value = #{v.inspect}.
        Allowed args: #{%w[model output_format columns_to_display].join(', ')}
      )
      Rails.logger.info msg
      @warnings.add(k, msg)
    end
  end

  def map_columns
    @columns = @model.columns.map do |col|
      data = col.as_json

      col.sql_type_metadata.as_json.each_key do |key|
        data[key] = col.sql_type_metadata.send(key)
      end

      data.with_indifferent_access
    end
  end
end
