require "./definition"

module Optarg
  abstract class OptionBase < ::Optarg::Definition
    def get_default
      raise "Should never be called."
    end

    def set_default(result)
      raise "Should never be called."
    end

    def validate(data)
    end
  end
end
