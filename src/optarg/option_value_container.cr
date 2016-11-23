module Optarg
  abstract class OptionValueContainer
    getter __strings : Definitions::StringOption::Typed::ValueHash
    getter __bools : Definitions::BoolOption::Typed::ValueHash
    getter __string_arrays : Definitions::StringArrayOption::Typed::ValueHash

    def initialize(parser)
      @__strings = Definitions::StringOption::Typed::ValueHash.new(parser)
      @__bools = Definitions::BoolOption::Typed::ValueHash.new(parser)
      @__string_arrays = Definitions::StringArrayOption::Typed::ValueHash.new(parser)
    end

    def [](klass : ::String.class)
      @__strings
    end

    def [](klass : ::Bool.class)
      @__bools
    end

    def [](klass : ::Array(::String).class)
      @__string_arrays
    end

    def __to_hash
      {
        :string => @__strings,
        :bool => @__bools,
        :array => {
          :string => @__string_arrays
        }
      }
    end

    def ==(other)
      __to_hash == other
    end

    def inspect
      __to_hash.inspect
    end
  end
end
