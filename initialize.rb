require 'sidekiq'
require 'redis'
require 'faraday'
require 'json'
require 'em-hiredis'

# Initialize Redis hostname and port.
#
# If we are running under OpenShift we need to use different
# connection.
#
if ENV['OPENSHIFT_GEAR_UUID']
  REDIS_CONF = {
    :host => ENV['OPENSHIFT_REDIS_HOST'],
    :port => ENV['OPENSHIFT_REDIS_PORT']
  }
  REDIS_URL = "redis://:#{ENV['REDIS_PASSWORD']}@#{REDIS_CONF[:host]}:#{REDIS_CONF[:port]}"
else
  REDIS_CONF = {
    :host => 'localhost',
    :port => '6379'
  }
  REDIS_URL = 'redis://localhost:6379'
end

# Load Sidekiq workers
#
require_relative './lib/workers'
