module Optarg::ValueTypes
  abstract class Base(T)
    macro __concrete
      class Value < ::Optarg::Value(TYPE)
      end

      class ValueHash < ::Optarg::ValueHash(TYPE)
      end
    end
  end
end
