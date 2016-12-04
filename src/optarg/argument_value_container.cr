module Optarg
  abstract class ArgumentValueContainer
    macro method_missing(call)
      {% if call.name =~ /^\w/ %}
        @__values.{{call}}
      {% else %}
        {{call}}
      {% end %}
    end

    getter __values = %w()
    getter __nameless = %w()
    getter __named : Definitions::StringArgument::Typed::ValueHash
    getter __string_arrays : Definitions::StringArrayArgument::Typed::ValueHash

    def initialize(parser)
      @__named = Definitions::StringArgument::Typed::ValueHash.new(parser)
      @__string_arrays = Definitions::StringArrayArgument::Typed::ValueHash.new(parser)
    end

    def [](klass : ::String.class)
      @__named
    end

    def [](klass : ::Array(::String).class)
      @__string_arrays
    end

    def ==(other)
      @__values == other
    end

    def inspect
      @__values.inspect
    end

    def [](index : Int)
      @__values[index]
    end

    def []?(index : Int)
      @__values[index]?
    end

    def [](start : Int, count : Int)
      @__values[start, count]
    end

    def [](range : Range(Int, Int))
      @__values[range]
    end
  end
end
