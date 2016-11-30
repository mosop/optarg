module Optarg::BashCompletion::Functions
  class Add < Function
    def initialize(g)
      super g
      body << <<-EOS
      if #{f(:keyerr)}; then return 1; fi
      local n=${#{found}[$#{key}]}
      if [[ "$n" == "" ]]; then
        n=1
      else
        let n+=1
      fi
      #{found}[$#{key}]=$n
      return 0
      EOS
    end
  end
end
