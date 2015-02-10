require 'sinatra/base'
require 'json'

class FakeTwitter < Sinatra::Base
  post '/frank/tweets' do
    content_type :json
    status 200
    {message: "Success!!!"}.to_json
  end

  post '/bad_user/tweets' do
    content_type :json
    status 400
    {message: "Bad User!!!"}.to_json
  end
end
