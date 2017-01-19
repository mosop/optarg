module Optarg
  class ModelClass
    property name : String
    getter? abstract : Bool
    getter! supermodel : ModelClass?

    def initialize(@supermodel, @name, @abstract)
    end

    def supermodel
      supermodel?.not_nil!
    end
  end
end
