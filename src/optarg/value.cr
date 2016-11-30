module Optarg
  abstract class Value(T)
    include ::Comparable(Value(T))

    getter metadata : ValueMetadata(T)

    def initialize(@value = nil, metadata = nil)
      @metadata = metadata || ValueMetadata(T).new
      @metadata.value = self
    end

    @value : T?
    def get?
      @value
    end

    def get
      @value.as(T)
    end

    def set(value : T?)
      @value = value
    end

    def exists?
      !@value.nil?
    end

    def dup_value!
      self.class.dup_value! @value
    end

    def dup_value
      self.class.dup_value @value
    end

    def self.dup_value!(value)
      dup_value(value).as(T)
    end

    def self.dup_value(value)
      if value.nil?
        nil
      elsif value.responds_to?(:dup)
        value.dup
      else
        value
      end
    end

    def <=>(other : Value(T))
      if get?.nil?
        other.get?.nil? ? 0 : -1
      else
        other.get?.nil? ? 1 : compare_to(other)
      end
    end

    def string
      self.class.encode_to_string(@value)
    end

    abstract def compare_to(other)
  end
end
