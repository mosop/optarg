module Optarg::Completion::Functions
  class Act < Function
    def make
      if zsh?
        body << <<-EOS
        local -a a jids
        case $1 in
          alias)
            a=( "${(k)aliases[@]}" ) ;;
          arrayvar)
            a=( "${(k@)parameters[(R)array*]}" )
            ;;
          binding)
            a=( "${(k)widgets[@]}" )
            ;;
          builtin)
            a=( "${(k)builtins[@]}" "${(k)dis_builtins[@]}" )
            ;;
          command)
            a=( "${(k)commands[@]}" "${(k)aliases[@]}" "${(k)builtins[@]}" "${(k)functions[@]}" "${(k)reswords[@]}")
            ;;
          directory)
            a=( ${IPREFIX}${PREFIX}*${SUFFIX}${ISUFFIX}(N-/) )
            ;;
          disabled)
            a=( "${(k)dis_builtins[@]}" )
            ;;
          enabled)
            a=( "${(k)builtins[@]}" )
            ;;
          export)
            a=( "${(k)parameters[(R)*export*]}" )
            ;;
          file)
            a=( ${IPREFIX}${PREFIX}*${SUFFIX}${ISUFFIX}(N) )
            ;;
          function)
            a=( "${(k)functions[@]}" )
            ;;
          group)
            _groups -U -O a
            ;;
          hostname)
            _hosts -U -O a
            ;;
          job)
            a=( "${savejobtexts[@]%% *}" )
            ;;
          keyword)
            a=( "${(k)reswords[@]}" )
            ;;
          running)
            a=()
            jids=( "${(@k)savejobstates[(R)running*]}" )
            for job in "${jids[@]}"; do
              a+=( ${savejobtexts[$job]%% *} )
            done
            ;;
          stopped)
            a=()
            jids=( "${(@k)savejobstates[(R)suspended*]}" )
            for job in "${jids[@]}"; do
              a+=( ${savejobtexts[$job]%% *} )
            done
            ;;
          setopt|shopt)
            a=( "${(k)options[@]}" )
            ;;
          signal)
            a=( "SIG${^signals[@]}" )
            ;;
          user)
            a=( "${(k)userdirs[@]}" )
            ;;
          variable)
            a=( "${(k)parameters[@]}" )
            ;;
          *)
            a=( ${IPREFIX}${PREFIX}*${SUFFIX}${ISUFFIX}(N) )
            ;;
        esac
        compadd -- "${a[@]}"
        return 0
        EOS
      else
        body << <<-EOS
        #{f(:cur)}
        COMPREPLY=( $(compgen -A $1 -- "${#{cursor}}") )
        return 0
        EOS
      end
    end
  end
end
