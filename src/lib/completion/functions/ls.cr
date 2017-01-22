module Optarg::Completion::Functions
  class Ls < Function
    def make
      body << <<-EOS
      local a i max found arg act cmd
      a=()
      if [[ "$#{word}" =~ ^- ]]; then
        i=0
        while [ $i -lt ${##{keys}[@]} ]; do
          if #{f(:tag)} arg $i; then
            let i+=1
            continue
          fi
          found=${#{found}[$i]}
          if [[ "$found" == "" ]]; then
            found=0
          fi
          max=${#{occurs}[$i]}
          if [ $max -lt 0 ] || [ $found -lt $max ]; then
            a+=($(echo "${#{keys}[$i]}"))
          fi
          let i+=1
        done
      else
        if [ $#{arg_index} -lt ${##{args}[@]} ]; then
          arg=${#{args}[$#{arg_index}]}
          act=${#{acts}[$arg]}
          cmd=${#{cmds}[$arg]}
          if [[ "$act" != "" ]]; then
            #{f(:act)} $act
            return 0
          elif [[ "$cmd" != "" ]]; then
            a=($(eval $cmd))
          else
            a=($(echo "${#{words}[$arg]}"))
          fi
        fi
      fi
      if [ ${#a[@]} -gt 0 ]; then
        #{f(:add)} "${a[@]}"
        return 0
      fi
      #{f(:any)}
      return $?
      EOS
    end
  end
end
