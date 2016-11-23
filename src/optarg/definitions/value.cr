require "./base"

module Optarg::Definitions
  abstract class Value < Base
    macro inherited
      {%
        is_option = @type.superclass.id == "Optarg::Definitions::Option"
        is_argument = @type.superclass.id == "Optarg::Definitions::Argument"
        is_array = @type.superclass.id == "Optarg::Definitions::ArrayOption"
      %}
      {% unless @type.abstract? %}
        @default_value : Typed::Value?
        def default_value
          @default_value ||= Typed::Value.new(nil)
        end

        def initialize(names, metadata = nil, stop = nil, default : Typed::TYPE? = nil, required = nil, any_of : (::Array(Typed::Value) | ::Array(Typed::TYPE) | Nil) = nil)
          @default_value = Typed::Value.new(default)
          {% if is_option || is_argument %}
            require_value! if required
            any_value_of!(any_of) if any_of
          {% end %}
          super names, metadata: metadata, stop: stop
        end

        def get_value(parser)
          get_value?(parser).as(Typed::TYPE)
        end

        def get_typed_value(parser)
          Typed::Value.new(get_value?(parser))
        end

        {% if is_array %}
          def fallback_value(parser)
            set_value parser, Typed::TYPE.new
          end
        {% else %}
          def fallback_value(parser)
            set_default_value parser
          end
        {% end %}

        getter value_validations = [] of ValueValidations::Base(::{{@type}})

        def validate_value(parser)
          value_validations.each{|i| i.validate(parser, self)}
        end

        module Validations
          {% if is_option || is_argument %}
            class Required < ::Optarg::ValueValidations::Required(::{{@type}})
              def validate(parser, df)
                raise Error.new(parser, df) unless df.get_typed_value(parser).exists?
              end

              class Error < ::Optarg::ValidationError
                {% if is_option %}
                  getter option : DEFINITION_TYPE

                  def initialize(parser, @option)
                    super parser, "The #{@option.metadata.display_name} option is required."
                  end
                {% else %}
                  getter argument : DEFINITION_TYPE

                  def initialize(parser, @argument)
                    super parser, "The #{@argument.metadata.display_name} argument is required."
                  end
                {% end %}
              end
            end

            class Inclusion < ::Optarg::ValueValidations::Inclusion(::{{@type}})
              getter values : ::Array(Typed::Value)

              def initialize(@values : ::Array(Typed::Value))
              end

              def initialize(values : ::Array(Typed::TYPE))
                initialize values.map{|i| Typed::Value.new(i)}
              end

              def valid?(parser, df)
                typed = df.get_typed_value(parser)
                values.any?{|i| i == typed}
              end

              def validate(parser, df)
                raise Error.new(parser, df, values) unless valid?(parser, df)
              end

              class Error < ::Optarg::ValidationError
                getter values : ::Array(Typed::Value)

                {% if is_option %}
                  getter option : DEFINITION_TYPE

                  def initialize(parser, @option, @values)
                    super parser, "The #{@option.metadata.display_name} option must be one of #{values.map{|i| i.metadata.string}.join(", ")}."
                  end
                {% else %}
                  getter argument : DEFINITION_TYPE

                  def initialize(parser, @argument, @values)
                    super parser, "The #{@argument.metadata.display_name} argument must be one of #{values.map{|i| i.metadata.string}.join(", ")}."
                  end
                {% end %}
              end
            end
          {% end %}
        end

        {% if is_option || is_argument %}
          def require_value!
            value_validations << Validations::Required.new unless value_required?
          end

          def any_value_of!(values)
            value_validations << Validations::Inclusion.new(values)
          end
        {% end %}

        def value_required?
          value_validations.any? do |i|
            i.is_a?(::Optarg::ValueValidations::Required(::{{@type}})) ||
            i.is_a?(::Optarg::ValueValidations::Inclusion(::{{@type}}))
          end
        end

        def inclusion_values
          v = value_validations.find do |i|
            i.is_a?(::Optarg::ValueValidations::Inclusion(::{{@type}}))
          end
          v && v.values
        end
      {% end %}
    end

    include DefinitionMixins::FallbackValue
    include DefinitionMixins::ValidateValue

    def set_default_value(parser)
      set_value parser, default_value.dup_value! if default_value.exists?
    end
  end
end
