module Optarg::BashCompletion::Functions
  class Ls < Function
    def initialize(g)
      super g
      body << <<-EOS
      #{f(:cur)}
      local a=()
      local i=0
      local arg
      local act
      local cmd
      if [[ "$#{word}" =~ ^- ]]; then
        while [ $i -lt ${##{keys}[@]} ]; do
          if #{f(:tag)} arg $i; then
            let i+=1
            continue
          fi
          local found=${#{found}[$i]}
          if [[ "$found" == "" ]]; then
            found=0
          fi
          local max=${#{occurs}[$i]}
          if [ $max -lt 0 ] || [ $found -lt $max ]; then
            a+=(${#{keys}[$i]})
          fi
          let i+=1
        done
      else
        if [ $#{arg_index} -lt ${##{args}[@]} ]; then
          arg=${#{args}[$#{arg_index}]}
          act=${#{acts}[$arg]}
          cmd=${#{cmds}[$arg]}
          if [[ "$act" != "" ]]; then
            :
          elif [[ "$cmd" != "" ]]; then
            a=($($cmd))
          else
            a=(${#{words}[$arg]})
          fi
        fi
      fi
      if [[ "$act" != "" ]]; then
        COMPREPLY=( $(compgen -A $act -- "${#{cursor}}") )
        return 0
      elif [ ${#a[@]} -gt 0 ]; then
        COMPREPLY=( $(compgen -W "$(echo ${a[@]})" -- "${#{cursor}}") )
        return 0
      fi
      #{f(:any)}
      return $?
      EOS
    end
  end
end
