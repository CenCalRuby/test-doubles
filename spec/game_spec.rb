require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'

describe Game do

  describe '.save' do
    it 'should save a game' do
      game = Game.new('Game Name', 20, Player.new)

      expect(game.save).to eq(true)
    end
  end

  describe '.all' do
    it 'should return a list of all saved games' do
      5.times { |i| Game.new("Game#{i}", 1, Player.new).save }

      expect(Game.all.map(&:name)).to eq(%w(Game0 Game1 Game2 Game3 Game4))
    end
  end

  describe '.top_scores_for_player' do
    it 'should return the top scores for a player' do
      player = Player.new
      10.times do |i|
        Game.new("Game#{i}", i, player).save
      end

      scores = Game.top_scores_for_player(player)

      expect(scores.map(&:name)).to match_array(%w(Game9 Game8 Game7 Game6 Game5))
    end
  end
end
