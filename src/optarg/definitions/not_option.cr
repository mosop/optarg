module Optarg::Definitions
  class NotOption < Option
    class Typed < ValueTypes::Bool
    end

    getter! value_key : String

    def initialize(names, @value_key, metadata = nil, stop = nil)
      initialize names, metadata: metadata, stop: stop, default: nil
    end

    def visit(parser, name = nil)
      parser.options[Bool][value_key] = false
      Parser.new_node(parser[0..0], self)
    end

    def visit_concatenated(parser, name)
      visit parser, name
    end
  end
end
