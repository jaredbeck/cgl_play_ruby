require "app/card"
require "app/errors"
require "app/pile"

module CGL
  class Player
    def initialize(name, piles)
      @name = name
      @piles = piles
    end

    def move(from, to)
      card = pile(from).shift
      puts format("Move 1 card (%s) from: %s to: %s", card.name, from, to)
      pile(to).push(card)
    end

    def name
      @name
    end

    def pile(name)
      @piles.find { |p| p.name == name } || raise(PileNotFound, name)
    end

    def piles_to_s
      @piles.map { |pile|
        format("%s: %s", pile.name, pile.cards_to_s)
      }
    end

    # Replace the contents of a pile without registering a movement, or
    # triggering anything.
    def set_pile(name, cards)
      pile(name).cards = cards
    end
  end
end
