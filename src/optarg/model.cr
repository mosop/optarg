module Optarg
  abstract class Model
    macro inherited
      {%
        if @type.superclass == ::Optarg::Model
          is_root = true
          super_parser = "Optarg::Parser".id
          super_option_value_container = "Optarg::OptionValueContainer".id
          super_argument_value_container = "Optarg::ArgumentValueContainer".id
        else
          is_root = false
          super_parser = "#{@type.superclass}::Parser".id
          super_option_value_container = "#{@type.superclass}::OptionValueContainer".id
          super_argument_value_container = "#{@type.superclass}::ArgumentValueContainer".id
        end %}

      @@definitions : ::Optarg::DefinitionSet?
      def self.definitions
        @@definitions ||= begin
          {% if is_root %}
            ::Optarg::DefinitionSet.new(nil)
          {% else %}
            ::Optarg::DefinitionSet.new(::{{@type.superclass}}.definitions)
          {% end %}
        end
      end

      class OptionValueContainer < ::{{super_option_value_container}}
      end

      class ArgumentValueContainer < ::{{super_argument_value_container}}
      end

      class Parser < ::{{super_parser}}
        def data
          @data.value.as(::{{@type}})
        end

        def options
          (@options.value ||= OptionValueContainer.new(self)).as(OptionValueContainer)
        end

        def args
          (@args.value ||= ArgumentValueContainer.new(self)).as(ArgumentValueContainer)
        end
      end

      def __options
        __parser.options.as(::{{@type}}::OptionValueContainer)
      end

      def __args
        __parser.args.as(::{{@type}}::ArgumentValueContainer)
      end

      def __new_parser(argv)
        Parser.new(self, argv)
      end

      def __parser
        @__parser.value.as(::{{@type}}::Parser)
      end
    end

    def initialize(argv)
      @__parser.value = __new_parser(argv)
    end

    @__parser = Util::Variable(Parser).new

    def self.parse(argv, *args)
      __parse(argv, *args)
    end

    def self.__parse(argv, *args)
      new(argv, *args).tap do |o|
        o.__parse
      end
    end

    def __parse
      __parser.parse
    end

    def parse
      __parse
    end

    def options; __options; end
    def args; __args; end

    def __named_args; __args.__named; end
    def named_args; __named_args; end

    def __nameless_args; __args.__nameless; end
    def nameless_args; __nameless_args; end

    def __parsed_args; __args.__values; end
    def parsed_args; __parsed_args; end

    def __unparsed_args; __parser.unparsed_args; end
    def unparsed_args; __unparsed_args; end

    def __parsed_nodes; __parser.parsed_nodes; end
  end
end

require "./model/macros/*"
require "./model/dsl/*"
