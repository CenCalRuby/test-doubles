require 'spec_helper'
require_relative '../lib/twitter_client'

describe TwitterClient do

  describe '.post' do
    it 'should post messages to twitter' do
      result = TwitterClient.post('frank', 'hello')

      expect(result.code).to eq("200")
    end

    it 'should throw a 400 when a bad user is passed to it' do
      result = TwitterClient.post('bad_user', 'waht')

      expect(result.code).to eq("400")
    end
  end
end
