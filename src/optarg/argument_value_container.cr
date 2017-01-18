module Optarg
  class ArgumentValueContainer
    getter __strings : Definitions::StringArgument::Typed::ValueHash
    getter __string_arrays : Definitions::StringArrayArgument::Typed::ValueHash

    def initialize(@parser : Parser)
      @__strings = Definitions::StringArgument::Typed::ValueHash.new(parser)
      @__string_arrays = Definitions::StringArrayArgument::Typed::ValueHash.new(parser)
    end

    def [](klass : ::String.class)
      @__strings
    end

    def [](klass : ::Array(::String).class)
      @__string_arrays
    end

    def ==(other)
      @parser.parsed_args == other
    end

    def inspect
      @parser.parsed_args.inspect
    end

    def size
      @parser.parsed_args.size
    end

    def map
      @parser.parsed_args.map do |i|
        yield i
      end
    end

    def [](index : Int)
      @parser.parsed_args[index]
    end

    def []?(index : Int)
      @parser.parsed_args[index]?
    end

    def [](start : Int, count : Int)
      @parser.parsed_args[start, count]
    end

    def [](range : Range(Int, Int))
      @parser.parsed_args[range]
    end
  end
end
