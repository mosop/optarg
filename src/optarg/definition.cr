module Optarg
  abstract class Definition
    @names : ::Array(::String)
    @description : ::String

    getter :names
    getter :description

    def initialize(@names, desc = "")
      @description = desc
    end

    def key
      @names[0]
    end

    def is_name?(name)
      @names.includes?(name)
    end
  end
end
