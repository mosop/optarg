module Optarg::ValueTypes
  abstract class Bool < Base
    __concrete ::Bool

    class Value
      def self.encode_to_string(b)
        if b.nil?
          nil
        else
          b.to_s
        end
      end

      def compare_to(other)
        (get ? 1 : 0) <=> (other.get ? 1 : 0)
      end
    end
  end
end
