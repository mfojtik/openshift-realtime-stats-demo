require 'sinatra/base'

require_relative './lib/helpers/redis_helper'
require_relative './lib/helpers/app_helper'

class Router < Sinatra::Base

  helpers AppHelper, RedisHelper


  get '/' do
    "<code>Usage: /app/APPNAME-USER [eg. /app/stats-mfojtik]</code>"
  end

  get '/:name' do
    if has_haproxy?(params[:name])
      erb :stats
    else
      halt 400, "The application <code>#{app_url(params[:name])}</code> does not exists or haproxy is not enabled."
    end
  end

end
