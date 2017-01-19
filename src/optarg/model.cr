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
          superparser = "Optarg::Parser".id
          superdynamic_validation_context = "Optarg::DynamicValidationContext".id
          superlast_concrete = nil
        %}
      {% else %}
        {%
          is_root = false
          supermodel_class = "#{@type.superclass}::Class".id
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

      @@__klass = ::Optarg::ModelClass.new(
        supermodel: {{ is_root ? nil : "::#{@type.superclass}.__klass".id }},
        name: {{@type.name.split("::")[-1].underscore}},
        abstract: {{@type.abstract?}}
      )
      def self.__klass; @@__klass; end
      def self.klass; @@__klass; end

      @@__definitions = ::Optarg::DefinitionSet.new
      {% unless is_root %}
        ::{{@type.superclass}}.__definitions.all.each do |kv|
          @@__definitions << kv[1].subclassify(::{{@type}})
        end
      {% end %}

      def self.__definitions; @@__definitions; end
      def self.definitions; @@__definitions; end

      class ::Optarg::ModelClass
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
        end

        def __parser
          (@__parser.var ||= Parser.new(self)).as(Parser)
        end
      {% end %}
    end

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

    def parse; __parse; end
    def parser; __parser; end

    def __options; __parser.options; end
    def options; __options; end

    def __args; __parser.parsed_args; end
    def args; __args; end

    def __named_args; __parser.args.__strings; end
    def named_args; __named_args; end

    def __nameless_args; __parser.nameless_args; end
    def nameless_args; __nameless_args; end

    def __parsed_args; __parser.parsed_args; end
    def parsed_args; __parsed_args; end

    def __unparsed_args; __parser.unparsed_args; end
    def unparsed_args; __unparsed_args; end

    def __parsed_nodes; __parser.parsed_nodes; end

    def [](index : Int32)
      __parser.parsed_args[index]
    end

    def []?(index : Int32)
      __parser.parsed_args[index]?
    end

    def self.__with_self(*args)
      with self yield *args
    end
  end
end

require "./model/macros/*"
require "./model/dsl/*"
