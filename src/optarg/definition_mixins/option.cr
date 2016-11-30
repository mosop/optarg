require "./visit"
require "./visit_concatenated"

module Optarg::DefinitionMixins
  module Option
    macro included
      include ::Optarg::DefinitionMixins::Visit
      include ::Optarg::DefinitionMixins::VisitConcatenated

      module OptionModule
        def completion_max_occurs(gen)
          1
        end
      end

      include OptionModule
    end
  end
end
