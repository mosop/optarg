module Optarg::Definitions
  class BoolOption < Option
    class Typed < ValueTypes::Bool
    end

    def visit(parser, name = nil)
      parser.options[Bool][value_key] = true
      Parser.new_node(parser[0..0], self)
    end

    def visit_concatenated(parser, name)
      visit parser, name
    end
  end
end
