require "app/player"

module CGL
  class State
    attr_reader :players

    def initialize(rules, num_players)
      @players = create_players(rules, num_players)
      if rules.divide_cards?
        pile_name = rules.divide_cards_into_pile
        divide_cards_among_players(rules.cards, @players, pile_name)
      else
        raise "The rules do not describe a start state"
      end
    end

    private

    def assert_cards_divide_evenly(cards, players)
      num_cards = cards.length
      num_players = players.length
      if num_cards % num_players != 0
        warn format(
          "%d cards do not divide evenly among %d players",
          num_cards, num_players
        )
        exit 1
      end
    end

    def create_players(rules, num_players)
      Array.new(num_players) do |i|
        name = format("Player %d", i)
        piles = [
          Pile.new("deck", [])
        ]
        Player.new(name, piles)
      end
    end

    def divide_cards_among_players(cards, players, pile_name)
      assert_cards_divide_evenly(cards, players)
      cards_per_player = cards.length / players.length
      players.each_with_index { |player, i|
        start = i * cards_per_player
        player_cards = cards[start, cards_per_player]
        player.set_pile(pile_name, player_cards)
      }
    end
  end
end
