module Optarg::Definitions
  class StringOption < Option
    class Typed < ValueTypes::String
    end

    def visit(parser)
      raise MissingValue.new(parser, self, parser[0]) if parser.left < 2
      parser.options[String][key] = parser[1]
      Parser.new_node(parser[0..1], self)
    end

    def visit_concatenated(parser, name)
      raise UnsupportedConcatenation.new(parser, self)
    end
  end
end
