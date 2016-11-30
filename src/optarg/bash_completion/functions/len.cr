module Optarg::BashCompletion::Functions
  class Len < Function
    def initialize(g)
      super g
      body << <<-EOS
      if #{f(:keyerr)}; then return 1; fi
      #{len}=${#{lens}[$#{key}]}
      return 0
      EOS
    end
  end
end
