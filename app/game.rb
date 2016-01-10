require "app/errors"

module CGL
  class Game
    CMD_MOVE = /\Amove\s+(\S+)\s+(\S+)\Z/

    def initialize(players, input, output)
      @players = players
      @input = input
      @output = output
      @done = false
      @turn = 0
    end

    def run
      until @done
        @players.each do |p|
          begin
            print(p)
            evaluate(read, p)
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

    def evaluate(command, player)
      case command
      when "quit", "exit", "done"
        @done = true
      when "pass", "skip"
        nil
      when CMD_MOVE
        from, to = CMD_MOVE.match(command).captures
        player.move(from, to)
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
      @input.readline.strip
    end
  end
end
