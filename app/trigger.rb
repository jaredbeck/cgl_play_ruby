module CGL
  class Trigger
    attr_reader :cause, :effects

    def initialize(name, cause, effects)
      @name = name
      @cause = cause
      @effects = effects
    end

    def match?(*args)
      @cause.match?(*args)
    end
  end
end
