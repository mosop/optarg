module Optarg::BashCompletion::Functions
  class Lskey < Function
    def initialize(g)
      super g
      body << <<-EOS
      if ! #{f(:keyerr)}; then
        local act=(${#{acts}[$#{key}]})
        local cmd=(${#{cmds}[$#{key}]})
        local a
        if [[ "$act" != "" ]]; then
          :
        elif [[ "$cmd" != "" ]]; then
          a=($($cmd))
        else
          a=(${#{words}[$#{key}]})
        fi
        if [[ "$act" != "" ]]; then
          #{f(:cur)}
          COMPREPLY=( $(compgen -A $act -- "${#{cursor}}") )
          return 0
        elif [ ${#a[@]} -gt 0 ]; then
          #{f(:cur)}
          COMPREPLY=( $(compgen -W "$(echo ${a[@]})" -- "${#{cursor}}") )
          return 0
        fi
      fi
      #{f(:any)}
      return $?
      EOS
    end
  end
end
