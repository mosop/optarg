module Optarg::Completion::Functions
  class Cur < Function
    def make
      body << <<-EOS
      #{cursor}="${COMP_WORDS[COMP_CWORD]}"
      return 0
      EOS
    end
  end
end
