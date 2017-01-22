module Optarg::Definitions
  class Terminator < Base
    include DefinitionMixins::Visit

    def initialize(names, metadata = nil)
      super names, metadata: metadata, terminate: true
    end

    def visit(parser)
      Parser.new_node(parser[0..0], self)
    end

    def completion_length(gen)
      1
    end

    def completion_max_occurs(gen)
      1
    end
  end
end
