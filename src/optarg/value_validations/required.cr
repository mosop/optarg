module Optarg::ValueValidations
  abstract class Required(T) < Base(T)
    macro inherited
      __concrete
    end
  end
end
