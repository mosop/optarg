require "../spec_helper"

module OptargInternalSnakifyCompletionIdentifiersFeature
  class Model < Optarg::Model
  end

  it name do
    Model.__klass.name = "ke-ba-b"
    gen = Model.__klass.bash_completion.new_generator("prefix")
    gen.next_completion_for(Model.__klass).new_generator(gen).result.chomp.should eq <<-EOS
    prefix__ke_ba_b___keys=()
    prefix__ke_ba_b___args=()
    prefix__ke_ba_b___acts=()
    prefix__ke_ba_b___cmds=()
    prefix__ke_ba_b___lens=()
    prefix__ke_ba_b___nexts=()
    prefix__ke_ba_b___occurs=()
    prefix__ke_ba_b___tags=()
    prefix__ke_ba_b___words=()

    function prefix__ke_ba_b() {
      prefix___k=-1
      prefix___ai=0
      prefix___f=()
      while ! prefix__ke_ba_b___tag stop; do
        prefix___word
        prefix__ke_ba_b___key
        if prefix__ke_ba_b___tag term; then
          prefix___inc
          break
        fi
        if prefix___end; then
          prefix__ke_ba_b___ls
          return $?
        fi
        if [[ $prefix___w =~ ^- ]]; then
          if [ $prefix___k -eq -1 ]; then
            prefix___any
            return $?
          fi
          prefix___found
          prefix___inc
          prefix__ke_ba_b___len
          if [ $prefix___l -eq 1 ]; then
            continue
          fi
          if prefix___end; then
            prefix__ke_ba_b___lskey
            return $?
          fi
          prefix___inc
        else
          if prefix__ke_ba_b___arg; then
            if prefix___end; then
              prefix__ke_ba_b___lskey
              return $?
            fi
          fi
          prefix___inc
        fi
      done
      if [[ "${prefix__ke_ba_b___nexts[$prefix___k]}" != "" ]]; then
        prefix__ke_ba_b___next
      else
        prefix___any
      fi
      return $?
    }

    function prefix__ke_ba_b___arg() {
      if [ $prefix___ai -lt ${#prefix__ke_ba_b___args[@]} ]; then
        prefix___k=${prefix__ke_ba_b___args[$prefix___ai]}
        if ! prefix__ke_ba_b___tag varg; then
          let prefix___ai+=1
        fi
        return 0
      fi
      return 1
    }

    function prefix__ke_ba_b___key() {
      local i
      i=0
      while [ $i -lt ${#prefix__ke_ba_b___keys[@]} ]; do
        if [[ ${prefix__ke_ba_b___keys[$i]} == *' '$prefix___w' '* ]]; then
          prefix___k=$i
          return 0
        fi
        let i+=1
      done
      prefix___k=-1
      return 1
    }

    function prefix__ke_ba_b___len() {
      if prefix___keyerr; then return 1; fi
      prefix___l=${prefix__ke_ba_b___lens[$prefix___k]}
      return 0
    }

    function prefix__ke_ba_b___ls() {
      local a i max found arg act cmd
      a=()
      if [[ "$prefix___w" =~ ^- ]]; then
        i=0
        while [ $i -lt ${#prefix__ke_ba_b___keys[@]} ]; do
          if prefix__ke_ba_b___tag arg $i; then
            let i+=1
            continue
          fi
          found=${prefix___f[$i]}
          if [[ "$found" == "" ]]; then
            found=0
          fi
          max=${prefix__ke_ba_b___occurs[$i]}
          if [ $max -lt 0 ] || [ $found -lt $max ]; then
            a+=($(echo "${prefix__ke_ba_b___keys[$i]}"))
          fi
          let i+=1
        done
      else
        if [ $prefix___ai -lt ${#prefix__ke_ba_b___args[@]} ]; then
          arg=${prefix__ke_ba_b___args[$prefix___ai]}
          act=${prefix__ke_ba_b___acts[$arg]}
          cmd=${prefix__ke_ba_b___cmds[$arg]}
          if [[ "$act" != "" ]]; then
            prefix___act $act
            return 0
          elif [[ "$cmd" != "" ]]; then
            a=($(eval $cmd))
          else
            a=($(echo "${prefix__ke_ba_b___words[$arg]}"))
          fi
        fi
      fi
      if [ ${#a[@]} -gt 0 ]; then
        prefix___add "${a[@]}"
        return 0
      fi
      prefix___any
      return $?
    }

    function prefix__ke_ba_b___lskey() {
      if ! prefix___keyerr; then
        local act cmd a
        act=${prefix__ke_ba_b___acts[$prefix___k]}
        cmd=${prefix__ke_ba_b___cmds[$prefix___k]}
        if [[ "$act" != "" ]]; then
          :
        elif [[ "$cmd" != "" ]]; then
          a=($(eval $cmd))
        else
          a=($(echo "${prefix__ke_ba_b___words[$prefix___k]}"))
        fi
        if [[ "$act" != "" ]]; then
          prefix___act $act
          return 0
        elif [ ${#a[@]} -gt 0 ]; then
          prefix___add "${a[@]}"
          return 0
        fi
      fi
      prefix___any
      return $?
    }

    function prefix__ke_ba_b___tag() {
      local k
      if [[ "$2" == "" ]]; then
        if prefix___keyerr; then return 1; fi
        k=$prefix___k
      else
        k=$2
      fi
      if [[ ${prefix__ke_ba_b___tags[$k]} == *' '$1' '* ]]; then
        return 0
      fi
      return 1
    }
    EOS
  end
end
