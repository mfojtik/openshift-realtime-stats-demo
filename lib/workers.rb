# Configure and load Sidekiq workers here.
#
#
Sidekiq.configure_server do |config|
  config.redis = { url: REDIS_URL }
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL }
end

Sidekiq::Queue.new.clear
Sidekiq.redis do |r| 
  r.srem "queues", "app_queue"
  r.del  "queue:app_queue"
end

require_relative './workers/pull_stats_worker'
