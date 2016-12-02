module Optarg::BashCompletion::Functions
  class Ls < Function
    def initialize(g)
      super g
      body << <<-EOS
      #{f(:cur)}
      local a=()
      local i=0
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
          a=(${#{words}[${#{args}[$#{arg_index}]}]})
        fi
      fi
      if [ ${#a[@]} -gt 0 ]; then
        COMPREPLY=( $(compgen -W "$(echo ${a[@]})" -- "$#{cursor}") )
      else
        COMPREPLY=( $(compgen -o default -- "$#{cursor}") )
      fi
      return 0
      EOS
    end
  end
end
