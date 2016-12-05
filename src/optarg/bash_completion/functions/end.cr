module Optarg::BashCompletion::Functions
  class End < Function
    def initialize(g)
      super g
      body << <<-EOS
      if [ $#{index} -lt $COMP_CWORD ]; then
        return 1
      fi
      return 0
      EOS
    end
  end
end
