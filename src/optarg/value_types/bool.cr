require "./scalar"

module Optarg::ValueTypes
  abstract class Bool < Scalar(::Bool)
    __concrete

    class Value
      def compare_to(other)
        (get ? 1 : 0) <=> (other.get ? 1 : 0)
      end
    end
  end
end
