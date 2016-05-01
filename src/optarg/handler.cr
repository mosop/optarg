module Optarg
  abstract class Handler < ::Optarg::Definition
    def initialize(names, description = nil)
      super names, description: description
    end
  end
end
