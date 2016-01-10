module CGL
  class Error < StandardError; end
  class InvalidCommand < Error; end
  class PileNotFound < Error; end
end
