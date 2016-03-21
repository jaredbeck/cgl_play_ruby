require "app/action"
require "app/movement"
require "json"

module CGL
  class Rules
    def initialize(abs_path)
      @raw = JSON.parse(File.read(abs_path)).freeze
    end

    def action(name)
      raw = @raw.fetch("actions").find { |act| act.fetch("name") == name }
      raise "Action not found: #{name}" if raw.nil?
      phase = raw.fetch("phase")
      mandatory = raw.fetch("mandatory")
      moves = raw.fetch("movements").map { |move_name| movement(move_name) }
      Action.new(name, phase, mandatory, moves)
    end

    def action_names
      @raw.fetch("actions").map { |act| act.fetch("name") }
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

    def movement(name)
      raw = @raw.fetch("movements").find { |m| m.fetch("name") == name }
      name = raw.fetch("name")
      number = raw.fetch("number")
      from = raw.fetch("from")
      to = raw.fetch("to")
      Movement.new(name, number, from, to)
    end

    def piles
      @raw.fetch("piles").map { |raw| Pile.new(raw.fetch("name"), []) }
    end

    def shuffle_before_dividing?
      start_state.fetch("shuffle_before_dividing")
    end

    def start_state
      @raw.fetch("start_state")
    end
  end
end
