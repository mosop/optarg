module Optarg::BashCompletion::Functions
  class End < Function
    def initialize(g)
      super g
      body << <<-EOS
      if [ $#{index} -eq $COMP_CWORD ]; then
        return 0
      fi
      return 1
      EOS
    end
  end
end
