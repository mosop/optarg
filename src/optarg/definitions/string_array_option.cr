module Optarg::Definitions
  class StringArrayOption < ValueTypes::StringArray::Definition
    include DefinitionMixins::ValueOption
    include DefinitionMixins::ArrayValue

    def initialize(names, metadata = nil, stop = nil, default = nil, min = nil)
      super names, metadata: metadata, stop: stop
      initialize_array_value default: default, min: min
    end

    def visit(parser)
      raise MissingValue.new(parser, self, self) if parser.left < 2
      parser.options[Typed::Type][value_key] << Typed::ElementValue.decode(parser[1])
      Parser.new_node(parser[0..1], self)
    end
  end
end
