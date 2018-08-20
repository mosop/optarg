module Optarg
  # :nodoc:
  abstract class ValueHash(V)
    @raw = {} of String => V
    forward_missing_to @raw

    @fallbacked = {} of String => Bool
    @parser : Parser

    def initialize(@parser)
    end

    def ==(other : Hash)
      @raw == other
    end

    def [](key)
      fallback key
      @raw[key]
    end

    def []?(key)
      fallback key
      @raw[key]?
    end

    def fallback(key)
      return if @raw.has_key?(key)
      return if @fallbacked.has_key?(key)
      @fallbacked[key] = true
      if fb = @parser.definitions.values[key]?
        fb.fallback_value @parser
      end
    end
  end
end
