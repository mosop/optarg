module Optarg::Completion::Functions
  class Tag < Function
    def make
      body << <<-EOS
      local k
      if [[ "$2" == "" ]]; then
        if #{f(:keyerr)}; then return 1; fi
        k=$#{key}
      else
        k=$2
      fi
      if [[ ${#{tags}[$k]} == *' '$1' '* ]]; then
        return 0
      fi
      return 1
      EOS
    end
  end
end
