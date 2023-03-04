# frozen_string_literal: true

redis_configs = {
  url: 'redis://127.0.0.1:6379/3',
  namespace: 'quotations:sidekiq'
}

Sidekiq.configure_server do |config|
  config.redis = redis_configs
  schedule_file = 'config/schedule.yml'
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file)
end

Sidekiq.configure_client do |config|
  config.redis = redis_configs
end

# if Sidekiq.server?
#   cron = Ztimer.new(concurrency: 5)
#   cron.every(60 * 1000){ SyncCintEventsJob.perform_later }
#   cron.every(5 * 60 * 1000){ ProcessCintEventsJob.perform_later }
# end
