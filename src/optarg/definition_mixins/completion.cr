module Optarg::DefinitionMixins
  module Completion
    macro included
      module CompletionModule
        abstract def completion_length(gen) : Int32
        abstract def completion_max_occurs(gen) : Int32

        @completion_words : Array(String)?
        @completion_command : String?
        @completion_action : Symbol?

        def initialize_completion(complete)
          case complete
          when Array(String)
            @completion_words = complete
          when String
            @completion_command = complete
          when Symbol
            @completion_action = complete
          when Nil
          else
            raise "Unknown completion type: #{complete}"
          end
        end

        def completion_words(gen) : Array(String)?
          @completion_words
        end

        def completion_command(gen) : String?
          @completion_command
        end

        def completion_action(gen) : Symbol?
          @completion_action
        end

        def completion_next_models_by_value(gen) : Hash(String, ModelClass)?
        end
      end

      include CompletionModule
    end
  end
end
