module Optarg::BashCompletion::Functions
  class Reply < Function
    def initialize(g)
      super g
      if g.first?
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
          #{f(:len)}
          if [ $#{len} -eq 1 ]; then
            #{f(:add)}
            #{f(:inc)}
            continue
          fi
          #{f(:inc)}
          if #{f(:end)}; then
            #{f(:lskey)}
            return $?
          fi
          #{f(:add)}
        else
          if #{f(:arg)}; then
            #{f(:inc)}
            if [[ ${#{nexts}[$#{key}]} != "" ]]; then
              #{f(:next)}
              return $?
            fi
          else
            #{f(:inc)}
          fi
        fi
      done
      #{f(:any)}
      return $?
      EOS
    end
  end
end
