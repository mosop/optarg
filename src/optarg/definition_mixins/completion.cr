module Optarg::DefinitionMixins
  module Completion
    macro included
      module CompletionModule
        abstract def completion_length(gen) : Int32
        abstract def completion_max_occurs(gen) : Int32

        @completion : String?

        def initialize_completion(complete)
          @completion = complete
        end

        def completion_words(gen) : Array(String)?
        end

        def completion_command(gen) : String?
          @completion
        end

        def completion_next_models_by_value(gen) : Hash(String, ModelClass)?
        end
      end

      include CompletionModule
    end
  end
end
