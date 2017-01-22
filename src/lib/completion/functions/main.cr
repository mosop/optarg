module Optarg::Completion::Functions
  class Main < Function
    def make
      if g.first?
        if zsh?
          body << <<-EOS
          (( COMP_CWORD = CURRENT - 1 ))
          COMP_WORDS=($(echo ${words[@]}))
          EOS
        end
        body << <<-EOS
        #{index}=1
        EOS
      end
      body << <<-EOS
      #{key}=-1
      #{arg_index}=0
      #{found}=()
      while ! #{f(:tag)} stop; do
        #{f(:word)}
        #{f(:key)}
        if #{f(:tag)} term; then
          #{f(:inc)}
          break
        fi
        if #{f(:end)}; then
          #{f(:ls)}
          return $?
        fi
        if [[ $#{word} =~ ^- ]]; then
          if [ $#{key} -eq -1 ]; then
            #{f(:any)}
            return $?
          fi
          #{f(:found)}
          #{f(:inc)}
          #{f(:len)}
          if [ $#{len} -eq 1 ]; then
            continue
          fi
          if #{f(:end)}; then
            #{f(:lskey)}
            return $?
          fi
          #{f(:inc)}
        else
          if #{f(:arg)}; then
            if #{f(:end)}; then
              #{f(:lskey)}
              return $?
            fi
          fi
          #{f(:inc)}
        fi
      done
      if [[ "${#{nexts}[$#{key}]}" != "" ]]; then
        #{f(:next)}
      else
        #{f(:any)}
      fi
      return $?
      EOS
    end

    def name
      g.entry_point
    end
  end
end
