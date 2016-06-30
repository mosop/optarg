require "./option_base"

module Optarg
  abstract class Argument < ::Optarg::OptionBase
    @default : ::String?

    def initialize(name, metadata = nil, @default = nil)
      super [name], metadata: metadata
    end

    def get_default
      @default
    end

    def set_default(data)
      return unless default = get_default
      data.__arguments[key] = default
    end

    def type
      :argument
    end
  end
end
