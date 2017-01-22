module Optarg
  # :nodoc:
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

    @bash_completion : Completion?
    def bash_completion
      @bash_completion ||= Completion.new(:bash, self)
    end

    @zsh_completion : Completion?
    def zsh_completion
      @zsh_completion ||= Completion.new(:zsh, self)
    end
  end
end
