module Optarg
  abstract class Model
    macro inherited
      {% if @type.superclass == ::Optarg::Model %}
        {%
          is_root = true
          super_model_class = "Optarg::ModelClass".id
          super_parser = "Optarg::Parser".id
          super_option_value_container = "Optarg::OptionValueContainer".id
          super_argument_value_container = "Optarg::ArgumentValueContainer".id
        %}
      {% else %}
        {%
          is_root = false
          super_model_class = "#{@type.superclass}::Class".id
          super_parser = "#{@type.superclass}::Parser".id
          super_option_value_container = "#{@type.superclass}::OptionValueContainer".id
          super_argument_value_container = "#{@type.superclass}::ArgumentValueContainer".id
          %}
      {% end %}

      class Class < ::{{super_model_class}}
        def self.instance
          @@instance.var ||= Class.new
        end

        def name
          {{@type.name.split("::")[-1].underscore}}
        end

        def model
          ::{{@type}}
        end

        def supermodel?
          {% unless is_root %}
            ::{{super_model_class}}.instance
          {% end %}
        end

        def default_definitions
          [] of ::Optarg::Definitions::Base
        end

        @definitions : ::Optarg::DefinitionSet?
        def definitions
          @definitions ||= ::Optarg::DefinitionSet.new(self).tap do |defs|
            default_definitions.each do |df|
              defs << df
            end
          end
        end

        @bash_completion : ::Optarg::BashCompletion?
        def bash_completion
          @bash_completion ||= ::Optarg::BashCompletion.new(self)
        end
      end

      class OptionValueContainer < ::{{super_option_value_container}}
      end

      class ArgumentValueContainer < ::{{super_argument_value_container}}
      end

      class Parser < ::{{super_parser}}
        def data
          @data.var.as(::{{@type}})
        end

        def options
          (@options.var ||= OptionValueContainer.new(self)).as(OptionValueContainer)
        end

        def args
          (@args.var ||= ArgumentValueContainer.new(self)).as(ArgumentValueContainer)
        end
      end

      def __options
        __parser.options.as(OptionValueContainer)
      end

      def __args
        __parser.args.as(ArgumentValueContainer)
      end

      def __parser
        (@__parser.var ||= Parser.new(self)).as(Parser)
      end

      def self.__klass
        @@__klass.var ||= Class.instance
      end
    end

    @@__klass = Util::Var(ModelClass).new
    @__parser = Util::Var(Parser).new

    getter __argv : Array(String)

    def initialize(@__argv)
    end

    def self.__parse(argv, *args)
      new(argv, *args).tap do |o|
        o.__parse
      end
    end

    def __parse
      __parser.parse
    end

    def self.klass; __klass; end
    def self.parse(argv, *args); __parse(argv, *args); end

    def self.__definitions; __klass.definitions; end
    def self.definitions; __definitions; end

    def parse; __parse; end
    def parser; __parser; end
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
