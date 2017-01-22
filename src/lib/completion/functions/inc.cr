module Optarg::Completion::Functions
  class Inc < Function
    def make
      body << <<-EOS
      let #{index}+=1
      return 0
      EOS
    end
  end
end
