module Optarg::BashCompletion::Functions
  class Next < Function
    def initialize(g, data)
      super g
      body << <<-EOS
      case $#{word} in
      EOS
      data.each do |k, v|
        gen = v.bash_completion.new_generator(g)
        cond = <<-EOS
        #{string(k)})
          #{gen.prefix}reply
          ;;
        EOS
        body << indent(cond)
      end
      body << <<-EOS
        *)
          #{f(:any)}
          ;;
      esac
      return $?
      EOS
    end
  end
end
