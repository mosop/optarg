module Optarg
  abstract class Option
    @names : ::Array(::String)
    @description : ::String

    getter :names
    getter :description

    private def initialize(@names, desc = "")
      @description = desc
    end

    def key
      @names[0]
    end

    def is_name?(name)
      @names.includes?(name)
    end

    abstract def set_default(result)
  end
end
