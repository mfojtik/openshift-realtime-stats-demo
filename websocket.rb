require 'bundler/setup'
require 'faye/websocket'
require 'rack'

# Gain access to the Sidekiq workers:
#
require_relative './initialize'

App = lambda do |env|

  if Faye::WebSocket.websocket?(env)

    @channel = EM::Channel.new
    params = Rack::Request.new(env).params

    redis = $redis.connect.dup

    redis.pubsub.subscribe('/data/%s' % params['app'])
    redis.pubsub.on(:message) { |c, m| @channel.push(m) }

    ws = Faye::WebSocket.new(env)

    ws.on :open do |event|
      PullStatsWorker.perform_async(params['app'])
      @sid = @channel.subscribe do |message|
        ws.send(message)
        sleep(2)
        PullStatsWorker.perform_async(params['app'])
      end
    end

    ws.on :message do |event|
      ws.send(event.data)
    end

    ws.on :close do |event|
      redis.pubsub.unsubscribe('/data/%s' % params['app'])
      @channel.unsubscribe(@sid)
      ws = nil
    end

    # Return async Rack response
    ws.rack_response

  else
    [301, {"Location" => '/app'}, []]
  end

end

def App.log(message)
  $stdout.puts message
end
