require "term/ansicolor"

module CGL
  class Output
    include Term::ANSIColor

    def initialize(stream)
      @stream = stream
    end

    def print(*args)
      @stream.print(*args)
    end

    def puts(*args)
      @stream.puts(*args)
    end

    def puts_bold_green(str)
      @stream.puts bold(green(str))
    end

    def puts_bold_red(str)
      @stream.puts bold(red(str))
    end
  end
end
