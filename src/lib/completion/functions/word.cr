module Optarg::Completion::Functions
  class Word < Function
    def make
      body << <<-EOS
      #{word}="${COMP_WORDS[$#{index}]}"
      return 0
      EOS
    end
  end
end
