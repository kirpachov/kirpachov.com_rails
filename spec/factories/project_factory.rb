# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    # name { Faker::Lorem.word }
    # description { Faker::Lorem.sentence }
    start_date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    end_date { Faker::Date.between(from: Date.today, to: 2.days.from_now) }
  end
end