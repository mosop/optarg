require "./metadata"

module Optarg
  abstract class Definition
    @names : ::Array(::String)
    getter :names

    @metadata : ::Optarg::Metadata?
    getter :metadata

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
