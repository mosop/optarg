module Optarg
  abstract class OptionValueContainer
    getter __strings = {} of ::String => ::String?
    getter __bools = {} of ::String => ::Bool?
    getter __string_arrays = {} of ::String => ::Array(::String)

    def [](klass : ::String.class)
      @__strings
    end

    def [](klass : ::Bool.class)
      @__bools
    end

    def [](klass : ::Array(::String).class)
      @__string_arrays
    end

    def __to_tuple
      {
        string: @__strings,
        bool: @__bools,
        array: {
          string: @__string_arrays
        }
      }
    end

    def ==(other)
      __to_tuple == other
    end

    def inspect
      __to_tuple.inspect
    end
  end
end
