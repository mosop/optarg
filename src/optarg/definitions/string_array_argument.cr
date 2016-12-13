module Optarg::Definitions
  class StringArrayArgument < Base
    include ValueTypes::StringArray::Definition
    include DefinitionMixins::ArrayValueArgument

    def initialize(names, metadata = nil, default = nil, min = nil, any_item_of = nil, complete = nil)
      super names, metadata: metadata, complete: complete
      initialize_array_value default: default, min: min, any_item_of: any_item_of
      initialize_completion complete
    end

    def visitable?(parser)
      true
    end

    def visit(parser)
      parser.args[Typed::Type][value_key] << parser[0]
      parser.args.__values << parser[0]
      Parser.new_node(parser[0..0], self)
    end
  end
end
