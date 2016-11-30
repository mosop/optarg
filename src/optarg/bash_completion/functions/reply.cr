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
      while :; do
        if #{f(:end)}; then
          #{f(:ls)}
          return $?
        fi
        #{f(:word)}
        #{f(:key)}
        if #{f(:tag)} term; then
          #{f(:inc)}
          break
        elif [[ $#{word} =~ ^- ]]; then
          if [ $#{key} -eq -1 ]; then
            #{f(:any)}
            return $?
          fi
          #{f(:inc)}
          if #{f(:tag)} stop; then
            break
          fi
          #{f(:len)}
          if [ $#{len} -eq 1 ]; then
            #{f(:add)}
            continue
          fi
          if #{f(:end)}; then
            #{f(:lskey)}
            return $?
          fi
          #{f(:add)}
          #{f(:inc)}
          continue
        fi
        if #{f(:arg)}; then
          #{f(:inc)}
          if [[ ${#{nexts}[$#{key}]} != "" ]]; then
            #{f(:next)}
            return $?
          fi
        else
          #{f(:inc)}
        fi
      done
      #{f(:any)}
      return $?
      EOS
    end
  end
end
