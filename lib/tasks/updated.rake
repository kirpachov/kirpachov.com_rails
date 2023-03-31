# frozen_string_literal: true

# This task will run some scripts that has to be run after app in production is updated.
task :updated do
  Rake::Task["db:migrate"].invoke
  CreateProjectsByFile.run!
end
