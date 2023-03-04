# frozen_string_literal: true

DEFAULT_PERSISTANCE = 0.5

def persistance
  return @persistance if @persistance

  @persistance = ENV['RSPEC_PERSISTANCE'].to_i / 10.0
  valid_persistance = !(persistance.negative? || persistance > 1 || ENV['RSPEC_PERSISTANCE'].nil?)
  @persistance = DEFAULT_PERSISTANCE unless valid_persistance

  # TODO
  # Log this first time
  # puts "Persistance is #{persistance * 100}%"
  # unless valid_persistance
  #   puts <<-INFO
  #     Persistance indicates how many tests will be made.
  #     You can use the environment variable RSPEC_PERSISTANCE, like so

  #     RSPEC_PERSISTANCE=10 bundle exec rspec

  #     The value must be an integer between 0 and 10.
  #     The default value is 5.
  #     0 means that some tests will be skipped at all.
  #     10 means that it will be made as many tests as possible.
  #     This can be used to make faster(1) or deeper(10) tests.
  #   INFO
  # end

  @persistance
end

def limit(integer)
  return 0 if persistance.zero?
  return integer if persistance == 1

  (integer * persistance).to_i
end
