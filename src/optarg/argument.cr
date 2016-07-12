require "./option_base"

module Optarg
  abstract class Argument < ::Optarg::OptionBase
    getter default : String?
    @required : Bool

    def initialize(name, metadata, @default = nil, required = nil, group = nil)
      @required = !!required
      super [name], metadata: metadata, group: group
    end

    def set_default_to(data)
      with_default? do |default|
        data.__args.__named[key] = default
      end
    end

    def type
      :argument
    end

    def validate(data)
      raise ::Optarg::RequiredError.new(display_name) if @required && !data.__args.__named[key]?
    end

    def display_name
      key
    end

    def required?
      @required
    end
  end
end
