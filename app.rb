require "app/game"
require "app/player"

module CGL
  class App
    def initialize
      players = [
        Player.new("mage"),
        Player.new("hunter")
      ]
      @game = Game.new(players, $stdin, $stdout)
    end

    def run
      @game.run
    rescue Interrupt
      nil
    end
  end
end

CGL::App.new.run
