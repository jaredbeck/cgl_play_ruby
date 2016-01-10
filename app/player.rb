require "app/card"
require "app/errors"
require "app/pile"

module CGL
  class Player
    def initialize(name)
      @name = name
      deck = [
        Card.new("Ysera"),
        Card.new("Annoy-O-Tron")
      ]
      @piles = [
        Pile.new("hand", []),
        Pile.new("deck", deck)
      ]
    end

    def move(from, to)
      puts format("Move 1 card from: %s to: %s", from, to)
      card = pile(from).shift
      pile(to).push(card)
    end

    def name
      @name
    end

    def pile(name)
      @piles.find { |p| p.name == name } || raise(PileNotFound)
    end

    def piles_to_s
      @piles.map { |pile|
        format("%s: %s", pile.name, pile.cards_to_s)
      }
    end
  end
end
