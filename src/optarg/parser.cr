module Optarg
  abstract class Parser
    @data : Model
    getter argument_index = 0
    getter index = 0
    getter args : Array(String)
    @parsed_args : ArgumentValueList?
    getter unparsed_args : Array(String)
    getter parsed_nodes = [] of Array(String)
    getter left_args = %w()

    def initialize(@data, stops_on_error = false)
      @stops_on_error__p = stops_on_error
      @args, @unparsed_args = split_argv_by_double_dash(data.__argv)
    end

    private def split_argv_by_double_dash(argv)
      if i_or_nil = argv.index("--")
        i = i_or_nil.to_i
        parsed = i == 0 ? [] of ::String : argv[0..(i-1)]
        unparsed = i == argv.size-1 ? [] of ::String : argv[(i+1)..-1]
        {parsed, unparsed}
      else
        {argv, %w()}
      end
    end

    @stopped__p = false
    def stopped?
      @stopped__p
    end

    @unknown__p = false
    def unknown?
      @unknown__p
    end

    def stops_on_error?
      @stops_on_error__p
    end

    @invalid__p = true
    def valid?
      !@invalid__p
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
    rescue ex : ParsingError
      raise ex unless stops_on_error?
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
      while !stopped? && @index < args.size
        i = parse_next(index, args[@index])
        if i != @index
          @parsed_nodes << args[@index...i]
        end
        @index = i
      end
    ensure
      @left_args = args[index..-1] if @index < args.size
    end

    def parse_next(index, arg)
      if arg =~ /^-\w\w/
        parse_multiple_options(index, arg[1..-1].split("").map{|i| "-#{i}"})
      elsif arg =~ /^-/
        parse_single_option(index, arg)
      else
        parse_argument(index, arg)
      end
    end

    def parse_multiple_options(index, names)
      if unknown = names.find{|i| !options_and_handlers.any?{|j| j.is_name?(i)}}
        @unknown__p = true
        raise ::Optarg::UnknownOption.new(unknown)
      end

      names.each do |name|
        options_and_handlers.each do |df|
          if df.parse(name, data)
            if @stopped__p ||= df.stops?
              return index + 1
            end
          end
        end
      end
      return index + 1
    end

    def parse_single_option(index, arg)
      options_and_handlers.each do |df|
        i = df.parse(args, index, data)
        if i != index
          @stopped__p ||= df.stops?
          return i
        end
      end
      raise ::Optarg::UnknownOption.new(arg)
    end

    def parse_argument(index, arg)
      if @argument_index < model.__arguments.size
        df = model.__arguments.values[@argument_index]
        @stopped__p ||= df.stops?
        parsed_args.__named[df.key] = arg
        parsed_args << arg
        @argument_index += 1
      else
        parsed_args.__nameless << arg
        parsed_args << arg
      end
      index + 1
    end
  end
end
