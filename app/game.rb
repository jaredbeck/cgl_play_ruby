require "app/errors"

module CGL
  class Game
    CMD_MOVE = /\Amove\s+(\S+)\s+(\S+)\Z/
    PROMPT = "> ".freeze

    def initialize(rules, state, input, output)
      @rules = rules
      @state = state
      @action_names = @rules.action_names
      @input = input
      @output = output
      @done = false
      @turn = 0
    end

    def run
      until @done
        @state.players.each do |p|
          begin
            print(p)
            evaluate(read, p)
            break if @done
          rescue InvalidCommand
            retry
          end
        end
        @turn += 1
      end
    rescue EOFError
      nil
    end

    private

    def action(command, player)
      @rules.action(command).movements.each do |move|
        move.perform_by(player)
      end
    end

    def evaluate(command, player)
      case command
      when "quit", "exit", "done"
        @done = true
      when "pass", "skip"
        nil
      when *@action_names
        action(command, player)
      else
        puts "Invalid command"
        raise InvalidCommand
      end
    end

    def print(player)
      puts format("Turn: %d Player: %s", @turn, player.name)
      puts player.piles_to_s
    end

    def puts(str)
      @output.puts str
    end

    def read
      @output.print PROMPT
      @input.readline.strip
    end
  end
end
