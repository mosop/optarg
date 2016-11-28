require "./option"

module Optarg::Definitions
  abstract class ArrayOption < Option
    macro inherited
      {% unless @type.abstract? %}
        def initialize(names, metadata = nil, default = nil, min = nil)
          value_validations << Validations::MinimumLength.new(min) if min
          initialize names, metadata: metadata, stop: nil, default: default, required: nil
        end

        def visit(parser)
          raise MissingValue.new(parser, self, self) if parser.left < 2
          parser.options[Typed::TYPE][value_key] << Typed::ElementValue.decode(parser[1])
          Parser.new_node(parser[0..1], self)
        end

        on_after_parse do |df, parser|
          df.set_default_value_on_after_parse(parser)
        end

        def set_default_value_on_after_parse(parser)
          a = parser.options[Typed::TYPE][value_key]
          set_default_value parser if a.empty?
        end

        module Validations
          class MinimumLength < ::Optarg::ValueValidations::MinimumLengthOfArray(::{{@type}})
            def validate(parser, df)
              raise Error.new(parser, df, @min) if df.get_value(parser).size < @min
            end

            class Error < ::Optarg::ValidationError
              getter option : DEFINITION_TYPE
              getter min : Int32

              def initialize(parser, @option, @min)
                super parser, "The #{@option.metadata.display_name} option's length is #{@option.get_value(parser).size}, but #{@min} or more is expected."
              end
            end
          end
        end

        def minimum_length_of_array_value
          if df = value_validations.find{|i| i.is_a?(::Optarg::ValueValidations::MinimumLengthOfArray(::{{@type}}))}
            df.min
          else
            0
          end
        end
      {% end %}
    end

    def visit_concatenated(parser, name)
      raise UnsupportedConcatenation.new(parser, self)
    end
  end
end
