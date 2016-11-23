module Optarg
  class ValueMetadata(T)
    @value : Value(T)?

    def value
      @value.as(Value(T))
    end

    def value=(value : Value(T))
      @value = value
    end

    def string
      value.get?.to_s
    end
  end
end
