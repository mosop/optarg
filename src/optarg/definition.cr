require "./metadata"

module Optarg
  abstract class Definition
    @names : ::Array(::String)
    getter :names

    @metadata : ::Optarg::Metadata?
    def metadata; @metadata as ::Optarg::Metadata; end

    def initialize(@names, @metadata)
    end

    def key
      @names[0]
    end

    def is_name?(name)
      @names.includes?(name)
    end

    def parse(arg, data)
      raise "Not implemeted."
    end

    def parse(args, index, data)
      raise "Not implemeted."
    end
  end
end
