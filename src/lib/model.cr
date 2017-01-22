module Optarg
  # The base of model classes.
  abstract class Model
    macro inherited
      {%
        last_name = @type.name.split("::").last.id
      %}
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

      @@__klass = ::Optarg::ModelClass.new(
        supermodel: {{ is_root ? nil : "::#{@type.superclass}.__klass".id }},
        name: {{@type.name.split("::")[-1].underscore}},
        abstract: {{@type.abstract?}}
      )
      # :nodoc:
      def self.__klass; @@__klass; end

      {% unless is_root %}
        ::{{@type.superclass}}.__klass.definitions.all.each do |kv|
          @@__klass.definitions << kv[1].subclassify(::{{@type}})
        end
      {% end %}

      # The dedicated Optarg::Parser subclass for the `{{last_name}}` class.
      #
      # This class is automatically defined by the optarg library.
      {% if @type.abstract? %}
        abstract class Parser < ::{{superparser}}
          inherit_callback_group :validate, ::Proc(::{{@type}}, ::Nil)
        end
      {% else %}
        class Parser < ::{{superparser}}
          inherit_callback_group :validate, ::Proc(::{{@type}}, ::Nil)

          # Returns a target model instance.
          def data : ::{{@type}}
            @data.as(::{{@type}})
          end
        end

        # :nodoc:
        def __parser
          (@__parser.var ||= Parser.new(self)).as(Parser)
        end

        # :nodoc:
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

        # :nodoc:
        def self.__with_definition(df)
          yield DefinitionContext.new(df)
        end
      {% end %}
    end

    # :nodoc:
    def __klass; self.class.__klass; end

    @__parser = Util::Var(Parser).new

    # :nodoc:
    getter __argv : Array(String)

    # :nodoc:
    def initialize(@__argv)
    end

    # :nodoc:
    def self.__parse(argv, *args)
      new(argv, *args).tap do |o|
        o.__parse
      end
    end

    # Creates a new model instance and parses the *argv* arguments.
    #
    # Returns the created instance.
    def self.parse(argv : Array(String), *args)
      __parse(argv, *args)
    end

    # :nodoc:
    def __parse
      __parser.parse
    end

    # Returns an array that contains nameless argument values.
    def nameless_args; __parser.nameless_args; end

    # Returns an array that contains unparsed argument values.
    def unparsed_args; __parser.unparsed_args; end

    # Returns a value hash for String-type options and arguments.
    def [](klass : String.class)
      __parser.args[klass]
    end

    # Returns a value hash for Bool-type options and arguments.
    def [](klass : Bool.class)
      __parser.args[klass]
    end

    # Returns a value hash for Array(String)-type options and arguments.
    def [](klass : Array(String).class)
      __parser.args[klass]
    end

    # Returns an argument value at the *index*.
    def [](index : Int32)
      __parser.parsed_args[index]
    end

    # Returns an argument value at the *index*.
    #
    # Returns nil if the *index* is out of range.
    def []?(index : Int32)
      __parser.parsed_args[index]?
    end

    # Iterates argument values.
    def each
      __parser.parsed_args.each do |i|
        yield i
      end
    end

    # :nodoc:
    def self.__with_self(*args)
      with self yield *args
    end
  end
end

require "./model/*"
