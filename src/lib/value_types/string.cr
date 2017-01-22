module Optarg::ValueTypes
  class String < Base
    __concrete ::String

    class Value
      def self.encode_to_string(b)
        if b.nil?
          nil
        else
          b.to_s
        end
      end

      def self.decode(s)
        s
      end

      def compare_to(other)
        get <=> other.get
      end
    end
  end
end
