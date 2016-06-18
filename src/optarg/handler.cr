module Optarg
  abstract class Handler < ::Optarg::Definition
    def type
      :handler
    end
  end
end
