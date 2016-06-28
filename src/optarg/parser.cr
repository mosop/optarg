module Optarg
  class Parser
    def parse(model, data)
      args = data.__args_to_be_parsed

      model.__options.values.each do |option|
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
            (model.__options.values + model.__handlers.values).each do |definition|
              break if matched = definition.parse(letter, data)
            end
            raise ::Optarg::UnknownOption.new(letter) unless matched
          end
          data.__parsed_nodes << [arg]
          i += 1
        else
          (model.__options.values + model.__handlers.values).each do |definition|
            j = definition.parse(args, i, data)
            if j != i
              data.__parsed_nodes << args[i..(j-1)]
              i = j
              break
            end
          end
          if i == index
            raise ::Optarg::UnknownOption.new(args[i]) if args[i].starts_with?("-")
            data.__parsed_args << args[i]
            data.__parsed_nodes << [args[i]]
            i += 1
          end
        end
        index = i
      end
    end
  end
end
