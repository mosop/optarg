require "./option_base"

module Optarg
  abstract class Argument < ::Optarg::OptionBase
    @default : ::String?
    @required : ::Bool

    def initialize(name, metadata = nil, @default = nil, required = nil)
      @required = !!required
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

    def validate(data)
      raise ::Optarg::RequiredError.new(key) if @required && !data.__arguments[key]?
    end
  end
end
