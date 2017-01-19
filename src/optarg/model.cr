module Optarg
  abstract class Model
    macro inherited
      {% if @type.superclass == ::Optarg::Model %}
        {%
          is_root = true
          supermodel_class = "Optarg::ModelClass".id
          superparser = "Optarg::Parser".id
          superlast_concrete = nil
        %}
      {% else %}
        {%
          is_root = false
          supermodel_class = "#{@type.superclass}::Class".id
          superparser = "#{@type.superclass}::Parser".id
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

      def self.__definitions; @@__klass.definitions; end
      def self.definitions; @@__klass.definitions; end

      {% unless is_root %}
        ::{{@type.superclass}}.__definitions.all.each do |kv|
          __definitions << kv[1].subclassify(::{{@type}})
        end
      {% end %}

      {% if @type.abstract? %}
        abstract class Parser < ::{{superparser}}
          inherit_callback_group :validate, ::Proc(::{{@type}}, ::Nil)
        end
      {% else %}
        class Parser < ::{{superparser}}
          inherit_callback_group :validate, ::Proc(::{{@type}}, ::Nil)

          def data
            @data.as(::{{@type}})
          end
        end

        def __parser
          (@__parser.var ||= Parser.new(self)).as(Parser)
        end

        class DefinitionContext
          @definition : ::Optarg::Definitions::Base

          def initialize(@definition)
          end

          def on_validate(&block : (::Optarg::ValidationContext, ::{{@type}}) ->)
            this = self
            Parser.on_validate do |parser|
              block.call ::Optarg::ValidationContext.new(parser, @definition), parser.data.as(::{{@type}})
              nil
            end
          end
        end

        def self.__with_definition(df)
          yield DefinitionContext.new(df)
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

    def __definitions; self.class.__definitions; end

    def [](index : Int32)
      __parser.parsed_args[index]
    end

    def []?(index : Int32)
      __parser.parsed_args[index]?
    end

    def each
      __parser.parsed_args.each do |i|
        yield i
      end
    end

    def self.__with_self(*args)
      with self yield *args
    end
  end
end

require "./model/macros/*"
require "./model/dsl/*"
