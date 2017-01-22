module Optarg::Completion::Functions
  class Add < Function
    def make
      if zsh?
        body << <<-EOS
        compadd -- "${@:1}"
        return 0
        EOS
      else
        body << <<-EOS
        #{f(:cur)}
        COMPREPLY=( $(compgen -W "$(echo ${@:1})" -- "${#{cursor}}") )
        return 0
        EOS
      end
    end
  end
end
