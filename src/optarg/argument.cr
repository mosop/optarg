require "./option_base"

module Optarg
  abstract class Argument < ::Optarg::OptionBase
    @default : String?
    @required : Bool

    def initialize(name, metadata, @default = nil, required = nil, group = nil)
      @required = !!required
      super [name], metadata: metadata, group: group
    end

    def get_default
      @default
    end

    def set_default(data)
      return unless default = get_default
      data.__args.__named[key] = default
    end

    def type
      :argument
    end

    def validate(data)
      raise ::Optarg::RequiredError.new(key) if @required && !data.__args.__named[key]?
    end
  end
end
