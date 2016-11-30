module Optarg::Definitions
  class StringArgument < ValueTypes::String::Definition
    include DefinitionMixins::ScalarValueArgument

    def initialize(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil)
      super names, metadata: metadata, stop: stop
      initialize_scalar_value_argument default: default, required: required, any_of: any_of
    end
  end
end
