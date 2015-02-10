class: center, middle

# Test Doubles

## Frank West
*Examples provided use rspec*

---
# Player Class
```ruby
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

# Stubs

--

* Simple object that stands in for another object during testing

--

* Best for testing query methods

--

* Strict by default

---
# Testing .top_scores for player

## Without stubs:

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

* Tests Game logic within Player tests

---
# Testing .top_scores for player

## With stubs:

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
--

* Acts very similar to a stub

--

* Sets an expectation that something will happen

--

* Best used for command methods, such as mailers or loggers

---


## With stub:

```ruby
describe '.share' do
  it 'should post the top 5 scores to twitter' do
    top_scores = double("top_scores")
    allow(Game).to receive(:top_scores_for_player).
      and_return(top_scores)

    allow(TwitterClient).to receive(:post).with('frank', top_scores)

    player = Player.new('frank')
    player.share
  end
end
```

* Using stubs when testing command methods will possibly result in a false
  positive test result

---
#### Test for .share with stubs
```ruby
describe '.share' do
  it 'should post the top 5 scores to twitter' do
    top_scores = double("top_scores")
    allow(Game).to receive(:top_scores_for_player).
      and_return(top_scores)

    allow(TwitterClient).to receive(:post).with('frank', top_scores)

    player = Player.new('frank')
    player.share
  end
end
```
--

#### Passes test

```ruby
def share
  TwitterClient.post(@name, top_scores)
end
```
--

#### Also passes test

```ruby
def share
end
```
---

# Testing .share for player

## With mock:

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
* Mock used here will fail if post is not called on TwitterClient

---

#### Test for .share with mocks
```ruby
describe '.share' do
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
--

#### Passes test
```ruby
def share
  TwitterClient.post(@name, top_scores)
end
```
--

#### Fails test
```ruby
def share
end
> # Failure/Error: expect(TwitterClient).to receive(:post).with('frank', top_scores)
```
---
# Spies

--

* Used in conjunction with a stub to provide the same tests as a mock

--

* Moves expectations (verifications) to the bottom of the tests allowing your tests to
  follow the pattern of setup, exercise, verify

---

#### Test for .share with spies
```ruby
describe '.share' do
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
```
---
# Fakes

--

* Implementations of real objects with plain ruby

--

* Can be great when you need to share between tests

--

* Costly due to the fact that you have to implement the actual code

--

* I see them as a last resort and rarely find uses for them

---

#### FakeTwitter - Fake Implementation of Twitter Service

```ruby
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
```
```ruby
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
```
---

class: center, middle

# Thank you

