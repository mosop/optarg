require "./metadata"

module Optarg
  abstract class Definition
    getter names : ::Array(::String)
    getter metadata : Metadata
    getter group : Symbol

    def initialize(@names, metadata = nil, group = nil)
      @metadata = metadata || Metadata.new
      @group = group || :default
    end

    def key
      @names[0]
    end

    def is_name?(name)
      @names.includes?(name)
    end

    def parse(arg, data)
      raise "Should never be called."
    end

    def parse(args, index, data)
      raise "Should never be called."
    end

    def type
      raise "Should never be called."
    end
  end
end
