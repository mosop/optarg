module Optarg::Definitions
  class StringOption < Base
    include ValueTypes::String::Definition
    include DefinitionMixins::ScalarValueOption

    def initialize(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil)
      super names, metadata: metadata, stop: stop, complete: complete
      initialize_scalar_value_option default: default, required: required, any_of: any_of
    end

    def visit(parser)
      raise MissingValue.new(parser, self, parser[0]) if parser.left < 2
      parser.options[String][value_key] = parser[1]
      Parser.new_node(parser[0..1], self)
    end

    def visit_concatenated(parser, name)
      raise UnsupportedConcatenation.new(parser, self)
    end

    def completion_length(gen)
      2
    end
  end
end
