module Optarg::Definitions
  class NotOption < Base
    include ValueTypes::Bool::Definition
    include DefinitionMixins::ScalarValueOption

    getter bool : BoolOption

    def initialize(names, @bool : BoolOption, metadata = nil, stop = nil, default = nil)
      super names, metadata: metadata, stop: stop
      initialize_scalar_value_option default: default, required: nil, any_of: nil
    end

    def value_key
      bool.value_key
    end

    def visit(parser, name = nil)
      parser.options[Bool][value_key] = false
      Parser.new_node(parser[0..0], self)
    end

    def visit_concatenated(parser, name)
      visit parser, name
    end

    def completion_length(gen)
      1
    end

    def completion_max_occurs(gen)
      bool.default_value.get? == true ? 1 : 0
    end
  end
end
