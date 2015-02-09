require 'spec_helper'
require_relative '../lib/twitter_client'

describe TwitterClient do

  describe '.post' do
    it 'should post messages to twitter' do
      stub_request(:post, 'https://api.twitter.com/frank/tweets').
        to_return(:status => 200, :body => "", :headers => {})

      result = TwitterClient.post('frank', 'hello')

      expect(result.code).to eq("200")
    end
  end
end
