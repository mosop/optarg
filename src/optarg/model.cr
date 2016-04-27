require "./model/*"

module Optarg
  abstract class Model
    macro inherited
      {%
        if @type.superclass == ::Optarg::Model
          super_option = "Optarg::Option"
          super_handler = "Optarg::Handler"
          super_definition_set = "Optarg::DefinitionSet"
          definition_set_base = "nil"
        else
          super_option = "#{@type.superclass.id}::Option"
          super_handler = "#{@type.superclass.id}::Handler"
          super_definition_set = "#{@type.superclass.id}::DefinitionSet"
          definition_set_base = "::#{@type.superclass.id}.definition_set"
        end %}

      module Options
      end

      abstract class Option < ::{{super_option.id}}
      end

      abstract class Handler < ::{{super_handler.id}}
      end

      class DefinitionSet < ::{{super_definition_set.id}}
        def base
          {{definition_set_base.id}}
        end
      end

      @@definition_set = DefinitionSet.new

      def self.definition_set
        @@definition_set
      end

      def self.parse(argv)
        o = new(argv)
        ::Optarg::Parser.new.parse(definition_set, o)
        o
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
