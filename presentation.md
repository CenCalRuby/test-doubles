class: center, middle

# Test Doubles

## Frank West
*Examples provided use rspec*

---

# Types Of Test Doubles

1. Stubs

--

  Simple object that stands in for another object during testing

--

2. Mocks

--

  Very much like a stub, except that they themselves have expectations built
  into them

--

3. Spies

--

  Used in conjunction with a stub to provide the same tests as a mock

--

4. Fakes

--

  Implementations of real objects with plain ruby

---

# Stubs

--

* Simply stands in for another object in testing

--

* Best for testing query methods

--

* Strict by default

---
# Player Class
```ruby
class Player
  def initialize(name)
    @name = name
  end

  def top_scores
    Game.top_scores_for_player(self)
  end
end
```

---
# Game Class
```ruby
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
  end

  def self.all
    @@games
  end

  def self.top_scores_for_player(player)
    @@games.select {|x| x.player == player }.
      sort {|a,b| b.score <=> a.score}[0..4]
  end
end

```
---
# Testing .top_scores for player
Without stubs:

```ruby
describe Player do
  describe '.top_scores' do
    it 'should retrieve the top 5 scores for the player' do
      player = Player.new
      10.times do |i|
        Game.new("Game#{i}", i, player).save
      end

      expect(player.top_scores.map(&:name)).to match_array(
        %w(Game9 Game8 Game7 Game6 Game5))
    end
  end
end
```

* Test setup is complex

* Tests Game model logic within Player model tests

---
# Testing .top_scores for player

With stubs:

```ruby
describe Player do
  describe '.top_scores' do
    it 'should retrieve the top 5 scores for the player' do
      top_scores = double("top_scores")
      allow(Game).to receive(:top_scores_for_player).
        and_return(top_scores)

      player = Player.new

      expect(player.top_scores).to eq(top_scores)
    end
  end
end
```

---

# Mocks

---

# Testing .share for player

With stub:

```ruby
describe '.share' do
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
```

* Using stubs when testing command methods will possibly result in a false
  positive test result

---
# Testing .share for player

With mock:

```ruby
describe '.share'
  it 'should post the top 5 scores to twitter' do
    top_scores = double("top_scores")
    allow(Game).to receive(:top_scores_for_player).
      and_return(top_scores)

    expect(TwitterClient).to receive(:post).with('frank', top_scores)

    player = Player.new('frank')
    player.share
  end
end
```
---

# Spies

---

# Fakes

---

class: center, middle

# Thank you for joining us


