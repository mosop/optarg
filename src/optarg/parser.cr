module Optarg
  class Parser
    @index = 0

    def parse(model, data)
      args = data.__optarg_args_to_be_parsed

      model.options.values.each do |option|
        option.set_default data
      end

      while @index < args.size
        i = @index
        (model.options.values + model.handlers.values).each do |definition|
          j = definition.parse(args, i, data)
          if j != i
            data.__optarg_parsed_nodes << args[i..(j-1)]
            i = j
            break
          end
        end
        if i == @index
          raise ::Optarg::UnknownOption.new(args[i]) if args[i].starts_with?("-")
          data.__optarg_parsed_args << args[i]
          data.__optarg_parsed_nodes << [args[i]]
          i += 1
        end
        @index = i
      end
    end
  end
end
