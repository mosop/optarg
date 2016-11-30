module Optarg::BashCompletion::Functions
  class Any < Function
    def initialize(g)
      super g
      body << <<-EOS
      #{f(:cur)}
      COMPREPLY=( $(compgen -o default -- "${#{cursor}}") )
      return 0
      EOS
    end
  end
end
