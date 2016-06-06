module Optarg
  class Parser
    def parse(model, data)
      args = data.__optarg_args_to_be_parsed

      model.options.values.each do |option|
        option.set_default data
      end

      index = 0
      while index < args.size
        i = index
        arg = args[i]
        if arg =~ /^-\w\w/
          letters = arg[1..-1].split("").map{|i| "-#{i}"}
          matched = true
          letters.each do |letter|
            (model.options.values + model.handlers.values).each do |definition|
              break if matched = definition.parse(letter, data)
            end
            raise ::Optarg::UnknownOption.new(letter) unless matched
          end
          data.__optarg_parsed_nodes << [arg]
          i += 1
        else
          (model.options.values + model.handlers.values).each do |definition|
            j = definition.parse(args, i, data)
            if j != i
              data.__optarg_parsed_nodes << args[i..(j-1)]
              i = j
              break
            end
          end
          if i == index
            raise ::Optarg::UnknownOption.new(args[i]) if args[i].starts_with?("-")
            data.__optarg_parsed_args << args[i]
            data.__optarg_parsed_nodes << [args[i]]
            i += 1
          end
        end
        index = i
      end
    end
  end
end
