module Optarg
  class ModelClass
    property name : String
    getter? abstract : Bool
    getter! supermodel : ModelClass?
    getter definitions = DefinitionSet.new

    def initialize(@supermodel, @name, @abstract)
    end

    def supermodel
      supermodel?.not_nil!
    end
  end
end
