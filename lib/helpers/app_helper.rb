require 'csv'

module AppHelper

  def has_haproxy?(app_name)
    begin
      response = http_client(app_url(app_name)).get('/haproxy-status/;csv')
      true if response.status == 200
    rescue
      false
    end
  end

  def http_client(base_url)
    @client ||= Faraday.new(:url => base_url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def app_url(app_name)
    "http://#{app_name}.rhcloud.com"
  end

  def pull_app_stats(app_name)
    begin
      response = http_client(app_url(app_name)).get('/haproxy-status/;csv')
      CSV.parse(response.body)
    rescue
      false
    end
  end

end
