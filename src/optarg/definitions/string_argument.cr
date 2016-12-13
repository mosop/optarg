module Optarg::Definitions
  class StringArgument < Base
    include ValueTypes::String::Definition
    include DefinitionMixins::ScalarValueArgument

    def initialize(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil)
      super names, metadata: metadata, stop: stop, complete: complete
      initialize_scalar_value_argument default: default, required: required, any_of: any_of
    end

    def visitable?(parser)
      !parser.args[Typed::Type].has_key?(value_key)
    end

    def visit(parser)
      parser.args[Typed::Type][value_key] = parser[0]
      parser.args.__values << parser[0]
      Parser.new_node(parser[0..0], self)
    end
  end
end
