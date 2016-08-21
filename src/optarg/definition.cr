require "./metadata"

module Optarg
  abstract class Definition
    getter names : ::Array(::String)
    getter metadata : Metadata
    getter group : Symbol

    def initialize(@names, metadata = nil, group = nil, stop = nil)
      @metadata = metadata || Metadata.new
      @group = group || :default
      @stops__p = !!stop
    end

    @stops__p : Bool
    def stops?
      @stops__p
    end

    def key
      @names[0]
    end

    def matches?(name)
      @names.includes?(name)
    end

    def parse(args, data)
      raise "Should never be called."
    end

    def type
      raise "Should never be called."
    end
  end
end
