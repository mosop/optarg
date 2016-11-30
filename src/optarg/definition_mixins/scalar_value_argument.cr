module Optarg::DefinitionMixins
  module ScalarValueArgument
    macro included
      include ::Optarg::DefinitionMixins::ScalarValue
      include ::Optarg::DefinitionMixins::ValueArgument

      module ScalarValueArgumentModule
        def initialize_scalar_value_argument(default, required, any_of)
          initialize_scalar_value default: default, required: required, any_of: any_of
        end

        def value_validation_error_message_for(parser, validation : Validations::Required)
          "The #{metadata.display_name} argument is required."
        end

        def value_validation_error_message_for(parser, validation : Validations::Inclusion)
          "The #{metadata.display_name} argument must be one of #{validation.values.map{|i| i.metadata.string}.join(", ")}."
        end
      end

      include ScalarValueArgumentModule
    end
  end
end
