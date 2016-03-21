module CGL
  class Action
    attr_reader :movements

    def initialize(name, phase, mandatory, movements)
      @name = name
      @phase = phase
      @mandatory = mandatory
      @movements = movements
    end
  end
end
