require "./model/*"

module Optarg
  abstract class Model
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

    def [](index)
      @__optarg_parsed_args[index]
    end

    def []?(index)
      return self[index] if index < @__optarg_parsed_args.size
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
  end
end
