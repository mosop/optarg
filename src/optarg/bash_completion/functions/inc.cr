module Optarg::BashCompletion::Functions
  class Inc < Function
    def initialize(g)
      super g
      body << <<-EOS
      let #{index}+=1
      return 0
      EOS
    end
  end
end
