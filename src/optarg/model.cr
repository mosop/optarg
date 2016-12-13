module Optarg
  abstract class Model
    macro define_dynamic_definition(df)
      {%
        df = df.resolve if df.class_name == "Path"
        local = df.name.split("::").last.id
      %}

      class Class
        def with_definition(df : ::{{df}})
          yield Dynamic{{local}}.new(df)
        end
      end

      class Dynamic{{local}}
        getter definition : ::{{df}}

        def initialize(@definition)
        end

        def on_validate(&block : Dynamic{{local}}Context ->)
          this = self
          Parser.on_validate do |parser|
            block.call Dynamic{{local}}Context.new(parser, this.definition)
          end
        end
      end

      class Dynamic{{local}}Context < DynamicDefinitionContext
        include ::{{df}}::DynamicContext

        getter definition : ::{{df}}
      end
    end

    macro inherited
      {% if @type.superclass == ::Optarg::Model %}
        {%
          is_root = true
          supermodel_class = "Optarg::ModelClass".id
          superoption_value_container = "Optarg::OptionValueContainer".id
          superargument_value_container = "Optarg::ArgumentValueContainer".id
          superparser = "Optarg::Parser".id
          superdynamic_validation_context = "Optarg::DynamicValidationContext".id
          superlast_concrete = nil
        %}
      {% else %}
        {%
          is_root = false
          supermodel_class = "#{@type.superclass}::Class".id
          superoption_value_container = "#{@type.superclass}::OptionValueContainer".id
          superargument_value_container = "#{@type.superclass}::ArgumentValueContainer".id
          superparser = "#{@type.superclass}::Parser".id
          superdynamic_validation_context = "#{@type.superclass}::DynamicValidationContext".id
          superclass_id = @type.superclass.name.underscore.split("_").join("__").id
          superlast_concrete = @type.superclass.constant("LAST_CONCRETE___#{superclass_id}")
        %}
      {% end %}

      {%
        class_id = @type.name.underscore.split("::").join("__").id
        last_concrete_id = "LastConcrete_#{class_id}".id
      %}

      {% if @type.abstract? %}
        {%
          last_concrete = superlast_concrete
        %}
      {% else %}
        {%
          last_concrete = @type
        %}
      {% end %}

      {% if last_concrete %}
        alias {{last_concrete_id}} = ::{{last_concrete}}
      {% end %}

      class OptionValueContainer < ::{{superoption_value_container}}
      end

      class ArgumentValueContainer < ::{{superargument_value_container}}
      end

      class Class < ::Optarg::ModelClass
        def self.instance
          (@@instance.var ||= Class.new).as(Class)
        end

        def name
          {{@type.name.split("::")[-1].underscore}}
        end

        def model
          ::{{@type}}
        end

        def supermodel?
          {% unless is_root %}
            ::{{supermodel_class}}.instance
          {% end %}
        end

        def default_definitions
          [] of ::Optarg::Definitions::Base
        end

        @bash_completion : ::Optarg::Completion?
        def bash_completion
          @bash_completion ||= ::Optarg::Completion.new(:bash, self)
        end

        @zsh_completion : ::Optarg::Completion?
        def zsh_completion
          @zsh_completion ||= ::Optarg::Completion.new(:zsh, self)
        end

        @definitions : ::Optarg::DefinitionSet?
        def definitions
          @definitions ||= ::Optarg::DefinitionSet.new(self).tap do |defs|
            default_definitions.each do |df|
              defs << df
            end
          end
        end
      end

      abstract class DynamicDefinitionContext
        {% if last_concrete %}
          getter parser : ::{{last_concrete}}::Parser
        {% else %}
          getter parser : ::Optarg::Parser
        {% end %}

        def model
          parser.data
        end

        def initialize(@parser, @definition)
        end
      end

      define_dynamic_definition ::Optarg::Definitions::BoolOption
      define_dynamic_definition ::Optarg::Definitions::StringArgument
      define_dynamic_definition ::Optarg::Definitions::StringArrayArgument
      define_dynamic_definition ::Optarg::Definitions::StringArrayOption
      define_dynamic_definition ::Optarg::Definitions::StringOption

      {% unless @type.abstract? %}
        class Parser < ::Optarg::Parser
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
      {% end %}

      def self.__klass
        (@@__klass.var ||= Class.instance).as(Class)
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
