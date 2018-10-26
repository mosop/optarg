module Optarg::Definitions
  class StringArrayOption < Base
    include ValueTypes::StringArray::Definition
    include DefinitionMixins::ArrayValueOption

    def initialize(names, metadata = nil, stop = nil, default = nil, min = nil, any_item_of = nil, complete = nil)
      super names, metadata: metadata, stop: stop, complete: complete
      initialize_array_value default: default, min: min, any_item_of: any_item_of
    end

    def visit(parser)
      raise MissingValue.new(parser, self, parser[0]) if parser.left < 2
      parser.args[Typed::Type][value_key] << parser[1]
      Parser.new_node(parser[0..1], self)
    end

    def completion_length(gen)
      2
    end
  end
end
