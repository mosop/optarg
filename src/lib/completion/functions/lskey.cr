module Optarg::Completion::Functions
  class Lskey < Function
    def make
      body << <<-EOS
      if ! #{f(:keyerr)}; then
        local act cmd a
        act=${#{acts}[$#{key}]}
        cmd=${#{cmds}[$#{key}]}
        if [[ "$act" != "" ]]; then
          :
        elif [[ "$cmd" != "" ]]; then
          a=($(eval $cmd))
        else
          a=($(echo "${#{words}[$#{key}]}"))
        fi
        if [[ "$act" != "" ]]; then
          #{f(:act)} $act
          return 0
        elif [ ${#a[@]} -gt 0 ]; then
          #{f(:add)} "${a[@]}"
          return 0
        fi
      fi
      #{f(:any)}
      return $?
      EOS
    end
  end
end
