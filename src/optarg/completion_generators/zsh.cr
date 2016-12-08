class Optarg::CompletionGenerators
  class Zsh < Base
    def make_header
      super
      if first?
        @header << <<-EOS
        setopt localoptions ksharrays
        EOS
      end
    end
  end
end
