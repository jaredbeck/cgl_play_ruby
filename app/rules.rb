require "json"

module CGL
  class Rules
    def initialize(abs_path)
      @raw = JSON.parse(File.read(abs_path)).freeze
    end

    def cards
      @raw.fetch("cards").map { |card|
        Card.new(card.fetch("name"), card["value"])
      }
    end

    def divide_cards?
      !!@raw.dig("start_state", "divide_cards")
    end

    def divide_cards_into_pile
      start_state.fetch("divide_cards_into_pile")
    end

    def shuffle_before_dividing?
      start_state.fetch("shuffle_before_dividing")
    end

    def start_state
      @raw.fetch("start_state")
    end
  end
end
