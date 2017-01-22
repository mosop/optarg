module Optarg
  # :nodoc:
  class ValueContainer
    getter strings : ValueTypes::String::ValueHash
    getter bools : ValueTypes::Bool::ValueHash
    getter string_arrays : ValueTypes::StringArray::ValueHash

    def initialize(@parser : Parser)
      @strings = ValueTypes::String::ValueHash.new(parser)
      @bools = ValueTypes::Bool::ValueHash.new(parser)
      @string_arrays = ValueTypes::StringArray::ValueHash.new(parser)
    end

    def [](klass : String.class)
      @strings
    end

    def [](klass : Bool.class)
      @bools
    end

    def [](klass : Array(String).class)
      @string_arrays
    end
  end
end
