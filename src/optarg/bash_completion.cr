module Optarg
  class BashCompletion
    getter model : ModelClass

    def initialize(@model)
    end

    def generate
    end

    def new_generator(prefix : String)
      Generator.new(self, prefix)
    end

    def new_generator(previous : Generator)
      Generator.new(previous, self)
    end
  end
end
