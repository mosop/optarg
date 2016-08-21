module Optarg
  abstract class Parser
    struct Node
      getter args : Array(String)
      getter definitions : Array(Definition)

      def initialize(@args, @definitions)
      end
    end

    @data : Model
    getter args : Array(String)
    @argument_index = 0
    @index = 0
    @parsed_args : ArgumentValueList?
    getter unparsed_args = %w()
    getter parsed_nodes = [] of Node

    def initialize(@data, @args)
    end

    @stopped__p = false
    def stopped?
      @stopped__p
    end

    @terminated__p = false
    def terminated?
      @terminated__p
    end

    @options_and_arguments : Array(OptionBase)?
    def options_and_arguments
      @options_and_arguments ||= model.__options.values + model.__arguments.values
    end

    @options_and_handlers : Array(Definition)?
    def options_and_handlers
      @options_and_handlers ||= model.__options.values + model.__handlers.values
    end

    def parse
      preset_default
      parse_args
      postset_default
      validate
    end

    def preset_default
      options_and_arguments.each do |df|
        df.preset_default_to data
      end
    end

    def postset_default
      options_and_arguments.each do |df|
        df.postset_default_to data
      end
    end

    def validate
      options_and_arguments.each do |df|
        df.validate data
      end
    end

    def parse_args
      while !stopped? && !terminated? && @index < args.size
        @index = parse_next
      end
    ensure
      @unparsed_args = args[@index..-1] if @index < args.size
    end

    def parse_next
      arg = args[@index]
      if model.__terminator?(arg)
        @terminated__p = true
        @index + 1
      elsif arg =~ /^-\w\w/
        parse_multiple_options
      elsif arg =~ /^-/
        parse_single_option
      else
        parse_argument
      end
    end

    def parse_multiple_options
      names = args[@index][1..-1].split("").map{|i| "-#{i}"}
      dfs = [] of Definition
      parsed_nodes << Node.new([args[@index]], dfs)
      stopped = false
      names.each do |name|
        if df = options_and_handlers.find{|i| i.matches?(name)}
          raise UnsupportedConcatenation.new(name) if df.length >= 2
          df.parse [name], data
          stopped ||= df.stops?
        else
          raise UnknownOption.new(name)
        end
      end
      @stopped__p = stopped
      @index + 1
    end

    def parse_single_option
      name = args[@index]
      if df = options_and_handlers.find{|i| i.matches?(name)}
        next_index = @index + df.length
        parsed_nodes << Node.new(args[@index...([next_index, args.size].min)], [df])
        raise MissingValue.new(df.key) unless next_index <= args.size
        df.parse args[@index...next_index], data
        @stopped__p ||= df.stops?
        next_index
      else
        raise UnknownOption.new(name)
      end
    end

    def parse_argument
      arg = args[@index]
      if @argument_index < model.__arguments.size
        df = model.__arguments.values[@argument_index]
        @stopped__p ||= df.stops?
        parsed_args.__named[df.key] = arg
        parsed_args << arg
        parsed_nodes << Node.new([arg], [df] of Definition)
        @argument_index += 1
      else
        parsed_args.__nameless << arg
        parsed_args << arg
        parsed_nodes << Node.new([arg], [] of Definition)
      end
      @index + 1
    end
  end
end
