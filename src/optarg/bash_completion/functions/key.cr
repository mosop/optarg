module Optarg::BashCompletion::Functions
  class Key < Function
    def initialize(g)
      super g
      body << <<-EOS
      local i=0
      while [ $i -lt ${##{keys}[@]} ]; do
        if [[ ${#{keys}[$i]} == *' '$#{word}' '* ]]; then
          #{key}=$i
          return 0
        fi
        let i+=1
      done
      #{key}=-1
      return 1
      EOS
    end
  end
end
