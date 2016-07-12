require "./definition"

module Optarg
  abstract class OptionBase < ::Optarg::Definition
    def with_default?
      if default = self.default
        yield default
      end
    end

    def default
      raise "Should never be called."
    end

    def preset_default_to(data)
      raise "Should never be called."
    end

    def postset_default_to(data)
      raise "Should never be called."
    end

    def validate(data)
    end
  end
end
