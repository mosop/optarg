module Optarg
  abstract class Handler < ::Optarg::Definition
    def type
      :handler
    end

    def length
      1
    end
  end
end
