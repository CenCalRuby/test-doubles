require 'spec_helper'
require_relative '../lib/player'
require_relative '../lib/game'
require_relative '../lib/twitter_client'

describe Player do
  describe '.top_scores' do
    context 'no stubbing' do
      it 'should retrieve the top 5 scores for the player' do
        player = Player.new
        10.times do |i|
          Game.new("Game#{i}", i, player).save
        end

        expect(player.top_scores.map(&:name)).to match_array(
          %w(Game9 Game8 Game7 Game6 Game5))
      end
    end

    context 'stubbing' do
      it 'should retrieve the top 5 scores for the player' do
        top_scores = double("top_scores")
        allow(Game).to receive(:top_scores_for_player).
          and_return(top_scores)

        player = Player.new

        expect(player.top_scores).to eq(top_scores)
      end
    end
  end

  describe '.share' do
    context 'with stub' do
      it 'should post the top 5 scores to twitter' do
        top_scores = double("top_scores")
        allow(Game).to receive(:top_scores_for_player).
          and_return(top_scores)

        # will pass regardless of whether or not post actually gets called
        allow(TwitterClient).to receive(:post).with('frank', top_scores)

        player = Player.new('frank')
        player.share
      end
    end

    context 'with mock' do
      it 'should post the top 5 scores to twitter' do
        top_scores = double("top_scores")
        allow(Game).to receive(:top_scores_for_player).
          and_return(top_scores)

        expect(TwitterClient).to receive(:post).with('frank', top_scores)

        player = Player.new('frank')
        player.share
      end
    end

    context 'with spy' do
      it 'should post the top 5 scores to twitter' do
        top_scores = double("top_scores")
        allow(Game).to receive(:top_scores_for_player).
          and_return(top_scores)
        allow(TwitterClient).to receive(:post).with('frank', top_scores)

        player = Player.new('frank')
        player.share

        expect(TwitterClient).to have_received(:post).with('frank', top_scores)
      end
    end
  end
end
