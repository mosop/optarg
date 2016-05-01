module Optarg
  abstract class Option < ::Optarg::Definition
    @default_string : ::String?
    getter :default_string

    def initialize(names, description = nil, @default_string = nil)
      super names, description: description
    end

    abstract def set_default(result)
  end
end
