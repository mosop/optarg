module Optarg::BashCompletion::Functions
  class Keyerr < Function
    def initialize(g)
      super g
      body << <<-EOS
      if [[ "$#{key}" == "" ]] || [ $#{key} -lt 0 ]; then
        return 0
      fi
      return 1
      EOS
    end
  end
end
