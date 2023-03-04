# frozen_string_literal: true

require 'sidekiq_admin_constraint'
require 'sidekiq/web'

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount Sidekiq::Web => '/sidekiq', :constraints => SidekiqAdminConstraint
  require 'sidekiq/cron/web'

  defaults format: :json do # rubocop:disable Metrics/BlockLength
    scope module: :v1, path: 'v1' do # rubocop:disable Metrics/BlockLength
    end
  end
end
