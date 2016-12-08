module Optarg::Completion::Functions
  class End < Function
    def make
      body << <<-EOS
      if [ $#{index} -lt $COMP_CWORD ]; then
        return 1
      fi
      return 0
      EOS
    end
  end
end
