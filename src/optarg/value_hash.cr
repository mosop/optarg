module Optarg
  abstract class ValueHash(V) < Hash(String, V)
    @fallbacked = {} of String => Bool
    @parser : Parser

    def initialize(@parser)
      super()
    end

    def [](key)
      fallback key
      super
    end

    def []?(key)
      fallback key
      super
    end

    def fallback(key)
      return if has_key?(key)
      return if @fallbacked.has_key?(key)
      @fallbacked[key] = true
      if fb = @parser.definitions.values[key]?
        fb.fallback_value @parser
      end
    end
  end
end
