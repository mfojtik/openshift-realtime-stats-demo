require_relative '../helpers/redis_helper'
require_relative '../helpers/app_helper'
require 'json'

class PullStatsWorker

  include Sidekiq::Worker
  include RedisHelper
  include AppHelper

  def perform(app_name)
    if new_data = pull_app_stats(app_name)
      redis.publish('/data/%s' % app_name, JSON::dump(new_data))
    end
  end

end
