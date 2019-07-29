module Optarg::Definitions
  abstract class Handler < Base
    include DefinitionMixins::Option

    def completion_length(gen) : Int32
      1
    end
  end
end
