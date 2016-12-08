module Optarg::Completion::Functions
  class Any < Function
    def make
      body << <<-EOS
      #{f(:act)} file
      return $?
      EOS
    end
  end
end
