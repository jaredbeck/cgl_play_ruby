require "app/errors"

module CGL
  class Game
    CMD_MOVE = /\Amove\s+(\S+)\s+(\S+)\Z/
    PROMPT = "> ".freeze

    def initialize(rules, state, input, output)
      @rules = rules
      @state = state
      @action_names = @rules.action_names
      @triggers = @rules.triggers
      @input = input
      @output = output
      @done = false
      @turn = 0
      @stack = []
    end

    def run
      until @done
        @state.players.each do |p|
          turn(p)
          after_turn
          break if @done
        end
        @turn += 1
      end
    rescue EOFError
      nil
    end

    private

    def action(command, player)
      # push action movements on stack
      action = @rules.action(command)
      action.movements.each do |move|
        @stack.push(move)

        # evaluate triggers, which may push more things on stack
        @triggers.select do |tgr|
          if tgr.cause.match?(action)
            apply_trigger_effects(tgr, player)
          end
        end
      end

      drain_stack(player)
    end

    # If there's only one player left after a turn, they are the winner.
    # TODO: Check more often? Not just after turn?
    def after_turn
      if @state.players.count == 1
        announce_winner(@state.players[0])
        @done = true
      end
    end

    def announce_winner(player)
      @output.puts_bold_green "Winner: #{player.name}"
    end

    def apply_trigger_effects(tgr, player)
      tgr.effects.each do |effect|
        case effect.object
        when "player"
          # TODO: move to Player?
          if effect.causal
            player[effect.property] = effect.value
            unless player.playing
              @output.puts_bold_red "Lose: #{player.name}"
            end
          else
            raise "Unexpected player effect: causal: #{causal}"
          end
        else
          raise "Not yet implemented: Effect: #{effect.object}"
        end
      end
    end

    # Pop events off of the stack until it is empty.
    def drain_stack(player)
      until @stack.empty?
        stack_pop(player)
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
      @output.puts_bold_green format("Turn: %d Player: %s", @turn, player.name)
      puts player.piles_to_s
    end

    def puts(str)
      @output.puts str
    end

    def read
      @output.print PROMPT
      @input.readline.strip
    end

    def stack_pop(player)
      event = @stack.pop
      case event
      when Movement
        event.perform_by(player)
      else
        raise "Unexpected event in stack: #{event}"
      end

      # Do any pile triggers match?
      @triggers.select do |tgr|
        player.piles.each do |pile|
          if tgr.match?(pile)
            apply_trigger_effects(tgr, player)
          end
        end
      end
    end

    def turn(player)
      begin
        print(player)
        evaluate(read, player)
      rescue InvalidCommand
        retry
      end
    end
  end
end
