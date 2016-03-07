if ARGV.length != 2
  warn "Usage: ruby -I . app.rb [rule file] [num. players]"
  exit 1
end

require "app/game"
require "app/rules"
require "app/state"

module CGL
  class App
    def initialize(abs_path, num_players)
      rules = Rules.new(abs_path)
      state = State.new(rules, num_players.to_i)
      @game = Game.new(rules, state, $stdin, $stdout)
    end

    def run
      @game.run
    rescue Interrupt
      nil
    end
  end
end

CGL::App.new(*ARGV).run
