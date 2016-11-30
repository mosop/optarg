module Optarg::DefinitionMixins
  module ArrayValue
    macro included
      include ::Optarg::DefinitionMixins::Value
      include ::Optarg::DefinitionMixins::ValueOption

      module ArrayValueModule
        def initialize_array_value(default, min : Int32?)
          initialize_value default: default
          value_validations << Validations::MinimumLength.new(min) if min
        end

        def fallback_value(parser)
          set_value parser, Typed::Type.new
        end

        def value_required?
          value_validations.any? do |v|
            if v = v.as?(Validations::MinimumLength)
              v.min > 0
            end
          end
        end

        def visit_concatenated(parser, name)
          raise UnsupportedConcatenation.new(parser, self)
        end

        module Validations
          class MinimumLength < Typed::Validation
            getter min : Int32

            def initialize(@min)
            end

            def valid?(parser, df)
              df.get_value(parser).size >= min
            end
          end
        end

        def value_validation_error_message_for(parser, validation : Validations::MinimumLength)
          "The #{metadata.display_name} option's length is #{get_value(parser).size}, but #{validation.min} or more is expected."
        end

        def minimum_length_of_array_value
          value_validations.each do |i|
            if v = i.as?(Validations::MinimumLength)
              return v.min
            end
          end
          0
        end

        def set_default_value_on_after_parse(parser)
          a = parser.options[Typed::Type][value_key]
          set_default_value parser if a.empty?
        end

        def completion_length(gen)
          2
        end

        def completion_max_occurs(gen)
          -1
        end
      end

      on_after_parse do |df, parser|
        df.set_default_value_on_after_parse(parser)
      end

      include ArrayValueModule
    end
  end
end
