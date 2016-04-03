module CGL
  module Triggers
    class Effect
      attr_reader :object, :causal, :property, :value

      def initialize(object, causal, property, value)
        @object = object
        @causal = causal
        @property = property
        @value = value
      end
    end
  end
end
