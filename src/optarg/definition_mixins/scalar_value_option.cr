module Optarg::DefinitionMixins
  module ScalarValueOption
    macro included
      include ::Optarg::DefinitionMixins::ValueOption
      include ::Optarg::DefinitionMixins::ScalarValue

      module ScalarValueOptionModule
        def initialize_scalar_value_option(default, required, any_of)
          initialize_scalar_value default: default, required: required, any_of: any_of
        end

        def validation_error_message_for_existence(parser, validation)
          "The #{metadata.display_name} option is required."
        end

        def validation_error_message_for_inclusion(parser, validation)
          "The #{metadata.display_name} option must be one of #{validation.values.map{|i| i.metadata.string}.join(", ")}."
        end
      end

      include ScalarValueOptionModule
    end
  end
end
