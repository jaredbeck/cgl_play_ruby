module CGL
  class Movement
    def initialize(name, number, from, to)
      @name = name
      @number = number
      @from = from
      @to = to
    end

    def perform_by(player)
      player.move(@from, @to)
    end
  end
end
