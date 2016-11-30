module Optarg::BashCompletion::Functions
  class Cur < Function
    def initialize(g)
      super g
      body << <<-EOS
      #{cursor}="${COMP_WORDS[COMP_CWORD]}"
      return 0
      EOS
    end
  end
end
