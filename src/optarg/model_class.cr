module Optarg
  abstract class ModelClass
    @@instance = Util::Var(ModelClass).new

    abstract def name : String
    abstract def supermodel? : ModelClass?
    abstract def bash_completion : BashCompletion
    abstract def definitions : DefinitionSet

    def supermodel
      supermodel?.not_nil!
    end
  end
end
