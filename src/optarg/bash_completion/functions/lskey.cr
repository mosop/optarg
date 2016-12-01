module Optarg::BashCompletion::Functions
  class Lskey < Function
    def initialize(g)
      super g
      body << <<-EOS
      if #{f(:keyerr)}; then return 1; fi
      local a=(${#{words}[$#{key}]})
      if [ ${#a[@]} -gt 0 ]; then
        #{f(:cur)}
        COMPREPLY=( $(compgen -W "$(echo ${a[@]})" -- "$#{cursor}") )
        return 0
      fi
      #{f(:any)}
      return $?
      EOS
    end
  end
end
