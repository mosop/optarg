module Optarg::DefinitionMixins
  module Argument
    macro included
      include ::Optarg::DefinitionMixins::Visit

      module ArgumentModule
        abstract def visitable?(parser) : Bool

        def completion_length(gen)
          1
        end

        def completion_max_occurs(gen)
          1
        end
      end

      include ArgumentModule
    end
  end
end
