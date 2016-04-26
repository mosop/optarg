module Optarg
  abstract class Parser(T)
    @index = 0
    @result : T

    def self.parse(argv)
      result = model.new(argv)
      new(result).parse
      result
    end

    def initialize(@result)
      @index = 0
    end

    def parse
      self.class.model.option_set.each do |option|
        option.set_default @result
      end

      while @index < args.size
        i = @index
        self.class.model.option_set.each do |option|
          j = option.parse(args, i, @result)
          if j != i
            @result.__optarg_parsed_nodes << args[i..(j-1)]
            i = j
            break
          end
        end
        if i == @index
          raise ::Optarg::UnknownOption.new(args[i]) if args[i].starts_with?("-")
          @result.__optarg_parsed_args << args[i]
          @result.__optarg_parsed_nodes << [args[i]]
          i += 1
        end
        @index = i
      end
    end

    private def args
      @result.__optarg_args_to_be_parsed
    end
  end
end
