module Optarg::Definitions
  class BoolOption < Base
    include ValueTypes::Bool::Definition
    include DefinitionMixins::ScalarValueOption

    def initialize(names, metadata = nil, stop = nil, default = nil)
      super names, metadata: metadata, stop: stop
      initialize_scalar_value_option default: default, required: nil, any_of: nil
    end

    def visit(parser, name = nil)
      parser.args[Bool][value_key] = true
      Parser.new_node(parser[0..0], self)
    end

    def visit_concatenated(parser, name)
      visit parser, name
    end

    def completion_length(gen) : Int32
      1
    end

    def completion_max_occurs(gen) : Int32
      default_value.get? == true ? 0 : 1
    end
  end
end
