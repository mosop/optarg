require "./macros/*"
require "./dsl/*"

module Optarg
  abstract class Model
    macro inherited
      {%
        if @type.superclass == ::Optarg::Model
          is_root = true
          super_option = "Optarg::Option"
          super_argument = "Optarg::Argument"
          super_handler = "Optarg::Handler"
          super_option_metadata = "Optarg::Metadata"
          super_argument_metadata = "Optarg::Metadata"
          super_handler_metadata = "Optarg::Metadata"
          super_argument_value_list = "Optarg::ArgumentValueList"
        else
          is_root = false
          super_option = "#{@type.superclass.id}::Option"
          super_argument = "#{@type.superclass.id}::Argument"
          super_handler = "#{@type.superclass.id}::Handler"
          super_option_metadata = "#{@type.superclass.id}::Option::Metadata"
          super_argument_metadata = "#{@type.superclass.id}::Argument::Metadata"
          super_handler_metadata = "#{@type.superclass.id}::Handler::Metadata"
          super_argument_value_list = "#{@type.superclass.id}::ArgumentValueList"
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

      class ArgumentValueList < ::{{super_argument_value_list.id}}
      end

      @__parsed_args = ArgumentValueList.new
      def __parsed_args
        @__parsed_args as ArgumentValueList
      end

      @@__self_options = {} of ::String => ::Optarg::Option
      @@__options : ::Hash(::String, ::Optarg::Option)?
      def self.__options
        @@__options ||= begin
          {% if is_root %}
            h = {} of ::String => ::Optarg::Option
          {% else %}
            h = ::{{@type.superclass}}.__options.dup
          {% end %}
          h.merge(@@__self_options)
        end
      end

      @@__self_arguments = {} of ::String => ::Optarg::Argument
      @@__arguments : ::Hash(::String, ::Optarg::Argument)?
      def self.__arguments
        @@__arguments ||= begin
          {% if is_root %}
            h = {} of ::String => ::Optarg::Argument
          {% else %}
            h = ::{{@type.superclass}}.__arguments.dup
          {% end %}
          h.merge(@@__self_arguments)
        end
      end

      @@__self_handlers = {} of ::String => ::Optarg::Handler
      @@__handlers : ::Hash(::String, ::Optarg::Handler)?
      def self.__handlers
        @@__handlers ||= begin
          {% if is_root %}
            h = {} of ::String => ::Optarg::Handler
          {% else %}
            h = ::{{@type.superclass}}.__handlers.dup
          {% end %}
          h.merge(@@__self_handlers)
        end
      end

      def self.parse(argv, completes = false, stops_on_unknown = false)
        new(argv, completes: completes, stops_on_unknown: stops_on_unknown).__parse
      end

      def __parse
        ::Optarg::Parser.new.parse(::{{@type.id}}, self)
        self
      end
    end

    getter __argv : ::Array(::String)
    getter __args_to_be_parsed : ::Array(::String)
    getter __parsed_args : ::Optarg::ArgumentValueList?
    getter __left_args = [] of ::String
    getter __unparsed_args : ::Array(::String)
    getter __parsed_nodes = [] of ::Array(::String)

    @__options : NamedTuple(completes: Bool, stops_on_unknown: Bool)

    def initialize(@__argv, completes = false, stops_on_unknown = false)
      @__args_to_be_parsed, @__unparsed_args = __split_by_double_dash
      @__options = {completes: completes, stops_on_unknown: stops_on_unknown}
    end

    def completes?
      @__options[:completes]
    end

    def stops_on_unknown?
      @__options[:stops_on_unknown]
    end

    def __args
      __parsed_args
    end

    def args
      __args
    end

    def left_args
      __left_args
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
