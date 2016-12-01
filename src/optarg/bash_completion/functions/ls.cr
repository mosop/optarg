module Optarg::BashCompletion::Functions
  class Ls < Function
    def initialize(g)
      super g
      body << <<-EOS
      #{f(:cur)}
      local a=()
      local i=0
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
      if [ $#{arg_index} -lt ${##{args}[@]} ]; then
        a+=(${#{words}[${#{args}[$#{arg_index}]}]})
      fi
      COMPREPLY=( $(compgen -W "$(echo ${a[@]})" -- "$#{cursor}") )
      return 0
      EOS
    end
  end
end
