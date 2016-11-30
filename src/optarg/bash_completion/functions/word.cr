module Optarg::BashCompletion::Functions
  class Word < Function
    def initialize(g)
      super g
      body << <<-EOS
      #{word}="${COMP_WORDS[$#{index}]}"
      return 0
      EOS
    end
  end
end
