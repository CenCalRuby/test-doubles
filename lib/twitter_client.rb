require 'net/http'
require 'uri'
require 'json'

class TwitterClient

  def self.post(username, message)
    uri = URI("https://api.twitter.com/#{username}/tweets")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    request.body = {:tweet => message}.to_json

    http.request(request)
  end

  private

  def uri
  end
end
