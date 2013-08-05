load './websocket.rb'
load './router.rb'

ENV['OPENSHIFT_RUBY_IP'] ||= '127.0.0.1'
ENV['OPENSHIFT_RUBY_PORT'] ||= '9292'

Faye::WebSocket.load_adapter('puma')

EM.run {
  trap("INT") { EM.stop_event_loop; exit(0) }
  $redis =  EM::Hiredis.connect(REDIS_URL)
  events = Puma::Events.new($stdout, $stderr)
  binder = Puma::Binder.new(events)
  binder.parse(["tcp://#{ENV['OPENSHIFT_RUBY_IP']}:#{ENV['OPENSHIFT_RUBY_PORT']}"], App)
  app = Rack::URLMap.new("/app" => Router, "/" => App)
  server = Puma::Server.new(app, events)
  server.binder = binder
  server.run
}
