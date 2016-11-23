module Optarg::ValueTypes
  abstract class String < Scalar(::String)
    __concrete

    class Value
      def self.decode(s)
        s
      end

      def compare_to(other)
        get <=> other.get
      end
    end
  end
end
