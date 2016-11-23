module Optarg::ValueTypes
  abstract class Scalar(T) < Base(T)
    macro inherited
      alias TYPE = ::{{@type.superclass.type_vars[0].id}}
    end
  end
end
