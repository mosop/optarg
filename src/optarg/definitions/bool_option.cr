module Optarg::Definitions
  class BoolOption < Option
    class Typed < ValueTypes::Bool
    end

    @not : Array(String)?
    def not
      @not ||= %w()
    end

    def initialize(names, metadata = nil, stop = nil, default = nil, not : String | Array(String) | Nil = nil)
      @not = if not.is_a?(String)
        [not]
      else
        not
      end
      initialize names, metadata: metadata, stop: stop, default: default
    end

    def matches?(name)
      super || matches_to_not?(name)
    end

    def matches_to_not?(name)
      not.includes?(name)
    end

    def visit(parser, name = nil)
      parser.options[Bool][key] = !matches_to_not?(name || parser[0])
      Parser.new_node(parser[0..0], self)
    end

    def visit_concatenated(parser, name)
      visit parser, name
    end
  end
end
