require "../definitions/base"

module Optarg::ValueTypes
  abstract class Base
    macro __concrete(t, et = nil)
      {%
        is_root = @type.superclass.name.starts_with?("Optarg::ValueTypes::Base")
      %}
      {% if is_root %}
        alias Type = {{t}}

        class Value < ::Optarg::Value({{t}})
        end

        {% if et %}
          alias ElementType = {{et}}

          class ElementValue < ::Optarg::ValueTypes::{{et.id}}::Value
          end
        {% end %}

        class ValueHash < ::Optarg::ValueHash({{t}})
        end

        abstract class Definition < ::Optarg::Definitions::Base
          class Typed < ::{{@type}}
            abstract class Validation < ::Optarg::ValueValidation
            end
          end

          macro inherited
            ::Optarg::ValueTypes::Base.__inherit_definition ::{{@type}}, \{{@type}}
          end
        end
      {% end %}
    end

    macro __inherit_definition(value_type, type)
      {%
        type = type.resolve
        is_root = type.superclass.superclass.name == "Optarg::Definitions::Base"
        supertyped = "#{type.superclass}::Typed".id
      %}

      {% if is_root %}
        class Typed < ::{{supertyped}}
          class Value < ::{{supertyped}}::Value
          end

          class ValueHash < ::{{supertyped}}::ValueHash
          end

          abstract class Validation < ::{{supertyped}}::Validation
            macro inherited
              \{%
                is_root = @type.superclass.superclass.superclass.name == "Optarg::ValueValidation"
              \%}

              \{% if is_root %}
                def new_error(parser, df, message)
                  Error.new(parser, df, self, message)
                end

                class Error < ::Optarg::ValidationError
                  getter definition : Definition
                  getter validation : ::\{{@type}}

                  def initialize(parser, @definition, @validation, message)
                    super parser, message
                  end
                end
              \{% end %}
            end

            alias Definition = ::{{type}}

            abstract def valid?(parser, df)

            def validate(parser, df)
              unless valid?(parser, df)
                message = df.value_validation_error_message_for(parser, self)
                raise new_error(parser, df, message)
              end
            end
          end
        end
      {% end %}
    end
  end
end
