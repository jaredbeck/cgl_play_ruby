require 'forwardable'

module CGL
  class Pile
    attr_writer :cards
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

    def [](property)
      case property
      when "count", "size"
        size
      else
        raise "Unexpected pile property: #{property}"
      end
    end

    def size
      @cards.length
    end
  end
end
