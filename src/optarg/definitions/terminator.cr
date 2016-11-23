module Optarg::Definitions
  class Terminator < Base
    include DefinitionMixins::Visit

    def initialize(names, metadata = nil)
      super names, metadata: metadata, terminate: true
    end

    def visit(parser)
      Parser.new_node(parser[0..0], self)
    end
  end
end
