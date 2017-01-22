module Optarg::DefinitionMixins
  module ArrayValueOption
    macro included
      include ::Optarg::DefinitionMixins::ValueOption
      include ::Optarg::DefinitionMixins::ArrayValue

      module ArrayValueOptionModule
        def validation_error_message_for_minimum_length_of_array(parser, validation)
          "The count of the #{metadata.display_name} options is #{get_value(parser).size}, but #{validation.min} or more is expected."
        end

        def validation_error_message_for_element_inclusion(parser, validation)
          "Each element of the #{metadata.display_name} option must be one of #{validation.values.map{|i| i.metadata.string}.join(", ")}."
        end

        def visit_concatenated(parser, name)
          raise UnsupportedConcatenation.new(parser, self)
        end
      end

      include ArrayValueOptionModule
    end
  end
end
