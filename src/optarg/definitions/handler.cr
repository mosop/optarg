module Optarg::Definitions
  abstract class Handler < Base
    include DefinitionMixins::Visit
    include DefinitionMixins::VisitConcatenated
  end
end
