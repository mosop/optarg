module Optarg::DefinitionMixins
  module ArrayValueArgument
    macro included
      include ::Optarg::DefinitionMixins::ValueArgument
      include ::Optarg::DefinitionMixins::ArrayValue

      module ArrayValueArgumentModule
        def validation_error_message_for_minimum_length_of_array(parser, validation)
          "The count of the #{metadata.display_name} arguments is #{get_value(parser).size}, but #{validation.min} or more is expected."
        end

        def validation_error_message_for_element_inclusion(parser, validation)
          "Each element of the #{metadata.display_name} argument must be one of #{validation.values.map{|i| i.metadata.string}.join(", ")}."
        end
      end

      include ArrayValueArgumentModule
    end
  end
end
