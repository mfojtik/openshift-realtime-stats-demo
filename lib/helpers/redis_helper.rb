module RedisHelper

  def redis
    return @redis unless @redis.nil?
    @redis = Redis.new(REDIS_CONF)
    @redis.auth(ENV['REDIS_PASSWORD']) if ENV['REDIS_PASSWORD']
    @redis
  end

end
