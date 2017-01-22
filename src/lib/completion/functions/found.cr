module Optarg::Completion::Functions
  class Found < Function
    def make
      body << <<-EOS
      if #{f(:keyerr)}; then return 1; fi
      local n
      n=${#{found}[$#{key}]}
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
