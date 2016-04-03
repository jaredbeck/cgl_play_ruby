require "app/action"

module CGL
  module Triggers
    class Cause
      def initialize(object, name, property, operator, value)
        @object = object
        @name = name
        @property = property
        @operator = operator
        @value = value
      end

      def match?(obj)
        case obj
        when Action
          # Not yet implemented: possible matches: name, phase, movements
          false
        when Pile
          match_pile?(obj)
        else
          raise "Unexpected action: #{obj}"
        end
      end

      private

      # Compares a value, for example pile size, to @value, using
      # @operator, and returns a boolean.
      def eval_binary_operator(val)
        case @operator
        when "="
          val == @value
        else
          raise "Unexpected cause operator: #{@operator}"
        end
      end

      def match_pile?(pile)
        @name == pile.name && eval_binary_operator(pile[@property])
      end
    end
  end
end
