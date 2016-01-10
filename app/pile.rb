require 'forwardable'

module CGL
  class Pile
    extend Forwardable
    def_delegators :@cards, :shift, :unshift, :pop, :push

    def initialize(name, cards)
      @name = name
      @cards = cards
    end

    def cards_to_s
      @cards.map { |card| card.name }.join(", ")
    end

    def name
      @name
    end
  end
end
