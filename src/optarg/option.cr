module Optarg
  abstract class Option < ::Optarg::Definition
    abstract def set_default(result)
  end
end
