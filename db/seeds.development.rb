# frozen_string_literal: true

require 'faker'

Random.rand(5..15).times do

  Project.create!(
    start_date: Faker::Date.between(from: 2.days.ago, to: Date.today),
    end_date: Faker::Date.between(from: Date.today, to: 2.days.from_now),
    status: Project.statuses.keys.sample,
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph
  )
end

Project.statuses.keys.each do |status|
  Project::VISIBILITY_OPTIONS.each do |visibility|
    [Faker::Date.between(from: 2.days.ago, to: Date.today), nil].each do |start_date|
      [Faker::Date.between(from: Date.today, to: 2.days.from_now), nil].each do |end_date|

        pj = Project.new(
          start_date: start_date,
          end_date: end_date,
          status: status,
          visibility: visibility,
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
        )

        pj.save if pj.valid?
      end
    end
    # start_date = Faker::Date.between(from: 2.days.ago, to: Date.today)
    # end_date = Faker::Date.between(from: Date.today, to: 2.days.from_now)
  end
end

# Project.create!(
#   status: :done
# )

puts "Total projects: #{Project.count}"