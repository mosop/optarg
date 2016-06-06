require "./model/*"

module Optarg
  abstract class Model
    macro inherited
      {%
        if @type.superclass == ::Optarg::Model
          super_option = "Optarg::Option"
          super_handler = "Optarg::Handler"
          super_option_metadata = "Optarg::Metadata"
          super_handler_metadata = "Optarg::Metadata"
          merge_of_options = "@@self_options"
          merge_of_handlers = "@@self_handlers"
        else
          super_option = "#{@type.superclass.id}::Option"
          super_handler = "#{@type.superclass.id}::Handler"
          super_option_metadata = "#{@type.superclass.id}::Option::Metadata"
          super_handler_metadata = "#{@type.superclass.id}::Handler::Metadata"
          merge_of_options = "::#{@type.superclass.id}.options.merge(@@self_options)"
          merge_of_handlers = "::#{@type.superclass.id}.handlers.merge(@@self_handlers)"
        end %}

      abstract class Option < ::{{super_option.id}}
        abstract class Metadata < ::{{super_option_metadata.id}}
        end
      end

      abstract class Handler < ::{{super_handler.id}}
        abstract class Metadata < ::{{super_option_metadata.id}}
        end
      end

      @@self_options = {} of ::String => ::Optarg::Option
      @@options = {} of ::String => ::Optarg::Option

      def self.options
        @@options = {{merge_of_options.id}} if @@options.empty?
        @@options
      end

      @@self_handlers = {} of ::String => ::Optarg::Handler
      @@handlers = {} of ::String => ::Optarg::Handler

      def self.handlers
        @@handlers = {{merge_of_handlers.id}} if @@handlers.empty?
        @@handlers
      end

      def self.parse(argv)
        new(argv).parse
      end

      def parse
        ::Optarg::Parser.new.parse(::{{@type.id}}, self)
        self
      end
    end

    @__optarg_argv : ::Array(::String)
    @__optarg_args_to_be_parsed : ::Array(::String)
    @__optarg_parsed_args = [] of ::String
    @__optarg_unparsed_args : ::Array(::String)
    @__optarg_parsed_nodes = [] of ::Array(::String)

    getter :__optarg_argv
    getter :__optarg_args_to_be_parsed
    getter :__optarg_parsed_args
    getter :__optarg_unparsed_args
    getter :__optarg_parsed_nodes

    def initialize(@__optarg_argv)
      @__optarg_args_to_be_parsed, @__optarg_unparsed_args = __optarg_split_by_double_dash
    end

    def args
      @__optarg_parsed_args
    end

    def unparsed_args
      @__optarg_unparsed_args
    end

    private def __optarg_split_by_double_dash
      if i_or_nil = @__optarg_argv.index("--")
        i = i_or_nil.to_i
        parsed = i == 0 ? [] of ::String : @__optarg_argv[0..(i-1)]
        unparsed = i == @__optarg_argv.size-1 ? [] of ::String : @__optarg_argv[(i+1)..-1]
        {parsed, unparsed}
      else
        {@__optarg_argv, [] of ::String}
      end
    end

    private def __optarg_yield
      yield
    end
  end
end
