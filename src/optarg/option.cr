module Optarg
  abstract class Option < ::Optarg::Definition
    def type
      raise "Should not be called."
    end

    def get_default
      raise "Should not be called."
    end

    def set_default(result)
      raise "Should not be called."
    end
  end
end
