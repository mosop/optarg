module Optarg::ValueValidations
  abstract class MinimumLengthOfArray(T) < Base(T)
    macro inherited
      __concrete
    end

    getter min : Int32

    def initialize(@min)
    end
  end
end
