module Optarg::Completion::Functions
  class Len < Function
    def make
      body << <<-EOS
      if #{f(:keyerr)}; then return 1; fi
      #{len}=${#{lens}[$#{key}]}
      return 0
      EOS
    end
  end
end
