module Optarg::BashCompletion::Functions
  class Arg < Function
    def initialize(g)
      super g
      body << <<-EOS
      if [ $#{arg_index} -lt ${##{args}[@]} ]; then
        #{key}=${#{args}[$#{arg_index}]}
        let #{arg_index}+=1
        return 0
      fi
      return 1
      EOS
    end
  end
end
