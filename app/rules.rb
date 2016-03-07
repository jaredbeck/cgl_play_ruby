require "json"

module CGL
  class Rules
    def initialize(abs_path)
      @raw = JSON.parse(File.read(abs_path)).freeze
    end

    # @raises KeyError
    def cards
      @raw.fetch("cards").map { |card|
        Card.new(card.fetch("name"), card["value"])
      }
    end

    def divide_cards?
      !!@raw.dig("start_state", "divide_cards")
    end

    # @raises KeyError
    def divide_cards_into_pile
      @raw.fetch("start_state").fetch("divide_cards_into_pile")
    end
  end
end
