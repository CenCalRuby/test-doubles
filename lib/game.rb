class Game
  attr_reader :name, :score, :player
  @@games = []

  def initialize(name, score, player)
    @name = name
    @score = score
    @player = player
  end

  def save
    @@games << self
    true
  end

  def self.all
    @@games
  end

  def self.top_scores_for_player(player)
    @@games.select {|x| x.player == player }.
      sort {|a,b| b.score <=> a.score}[0..4]
  end
end
