class Player
  def initialize(name='Anonymous')
    @name = name
  end

  def top_scores
    Game.top_scores_for_player(self)
  end

  def share
    TwitterClient.post(@name, top_scores)
  end
end
