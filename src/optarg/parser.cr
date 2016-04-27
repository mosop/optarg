module Optarg
  class Parser
    @index = 0

    def initialize
      @index = 0
    end

    def parse(definition_set, result)
      args = result.__optarg_args_to_be_parsed

      definition_set.each_set do |set|
        set.options.each do |option|
          option.set_default result
        end
      end

      while @index < args.size
        i = @index
        definition_set.each do |definition|
          j = definition.parse(args, i, result)
          if j != i
            result.__optarg_parsed_nodes << args[i..(j-1)]
            i = j
            break
          end
        end
        if i == @index
          raise ::Optarg::UnknownOption.new(args[i]) if args[i].starts_with?("-")
          result.__optarg_parsed_args << args[i]
          result.__optarg_parsed_nodes << [args[i]]
          i += 1
        end
        @index = i
      end
    end
  end
end
