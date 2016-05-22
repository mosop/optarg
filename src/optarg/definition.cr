require "./metadata"

module Optarg
  abstract class Definition
    @names : ::Array(::String)
    @metadata : ::Optarg::Metadata?

    getter :names

    def initialize(@names, @metadata)
    end

    def key
      @names[0]
    end

    def is_name?(name)
      @names.includes?(name)
    end
  end
end
