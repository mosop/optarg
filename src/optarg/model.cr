require "./macros/*"
require "./dsl/*"

module Optarg
  abstract class Model
    macro inherited
      {%
        if @type.superclass == ::Optarg::Model
          super_option = "Optarg::Option"
          super_argument = "Optarg::Argument"
          super_handler = "Optarg::Handler"
          super_option_metadata = "Optarg::Metadata"
          super_argument_metadata = "Optarg::Metadata"
          super_handler_metadata = "Optarg::Metadata"
          merge_of_options = "@@__self_options"
          merge_of_arguments = "@@__self_arguments"
          merge_of_handlers = "@@__self_handlers"
        else
          super_option = "#{@type.superclass.id}::Option"
          super_argument = "#{@type.superclass.id}::Argument"
          super_handler = "#{@type.superclass.id}::Handler"
          super_option_metadata = "#{@type.superclass.id}::Option::Metadata"
          super_argument_metadata = "#{@type.superclass.id}::Argument::Metadata"
          super_handler_metadata = "#{@type.superclass.id}::Handler::Metadata"
          merge_of_options = "::#{@type.superclass.id}.__options.merge(@@__self_options)"
          merge_of_arguments = "::#{@type.superclass.id}.__arguments.merge(@@__self_arguments)"
          merge_of_handlers = "::#{@type.superclass.id}.__handlers.merge(@@__self_handlers)"
        end %}

      abstract class Option < ::{{super_option.id}}
        abstract class Metadata < ::{{super_option_metadata.id}}
        end
      end

      abstract class Argument < ::{{super_argument.id}}
        abstract class Metadata < ::{{super_argument_metadata.id}}
        end
      end

      abstract class Handler < ::{{super_handler.id}}
        abstract class Metadata < ::{{super_handler_metadata.id}}
        end
      end

      @@__self_options = {} of ::String => ::Optarg::Option
      @@__options = {} of ::String => ::Optarg::Option
      def self.__options
        @@__options = {{merge_of_options.id}} if @@__options.empty?
        @@__options
      end

      @@__self_arguments = {} of ::String => ::Optarg::Argument
      @@__arguments = {} of ::String => ::Optarg::Argument
      def self.__arguments
        @@__arguments = {{merge_of_arguments.id}} if @@__arguments.empty?
        @@__arguments
      end

      @@__self_handlers = {} of ::String => ::Optarg::Handler
      @@__handlers = {} of ::String => ::Optarg::Handler
      def self.__handlers
        @@__handlers = {{merge_of_handlers.id}} if @@__handlers.empty?
        @@__handlers
      end

      def self.parse(argv)
        new(argv).__parse
      end

      def __parse
        ::Optarg::Parser.new.parse(::{{@type.id}}, self)
        self
      end
    end

    @__argv : ::Array(::String)
    @__args_to_be_parsed : ::Array(::String)
    @__parsed_args = ::Optarg::ArgumentValueList.new
    @__unparsed_args : ::Array(::String)
    @__parsed_nodes = [] of ::Array(::String)
    @__arguments = {} of String => String

    getter :__argv
    getter :__args_to_be_parsed
    getter :__parsed_args
    getter :__unparsed_args
    getter :__parsed_nodes
    getter :__arguments

    def initialize(@__argv)
      @__args_to_be_parsed, @__unparsed_args = __split_by_double_dash
    end

    def __args
      @__parsed_args
    end

    def args
      __args
    end

    def unparsed_args
      __unparsed_args
    end

    private def __split_by_double_dash
      if i_or_nil = @__argv.index("--")
        i = i_or_nil.to_i
        parsed = i == 0 ? [] of ::String : @__argv[0..(i-1)]
        unparsed = i == @__argv.size-1 ? [] of ::String : @__argv[(i+1)..-1]
        {parsed, unparsed}
      else
        {@__argv, %w()}
      end
    end

    private def __yield
      yield
    end

    def parse
      __parse
    end
  end
end
