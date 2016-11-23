module Optarg::ValueValidations
  abstract class Inclusion(T) < Base(T)
    macro inherited
      __concrete
    end
  end
end
