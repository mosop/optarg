module Optarg::Completion::Functions
  class Next < Function
    @data : Hash(String, ModelClass)

    def initialize(g, @data)
      super g
    end

    def make
      body << <<-EOS
      case $#{word} in
      EOS
      @data.each do |k, v|
        gen = g.next_completion_for(v).new_generator(g)
        cond = <<-EOS
        #{string(k)})
          #{gen.entry_point}
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
