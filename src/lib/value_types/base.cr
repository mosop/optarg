require "../definitions/base"

module Optarg::ValueTypes
  abstract class Base
    macro __concrete(t, et = nil)
      {%
        is_root = @type.superclass.name == "Optarg::ValueTypes::Base"
      %}
      alias Type = {{t}}

      class Value < ::Optarg::Value({{t}})
      end

      class ValueHash < ::Optarg::ValueHash({{t}})
      end

      {% if et %}
        alias ElementType = {{et}}
        alias ElementValue = ::Optarg::ValueTypes::{{et.id}}::Value
      {% end %}

      module Definition
        macro included
          ::Optarg::ValueTypes::Base.__include_definition ::{{@type}}, \{{@type}}
        end
      end
    end

    macro __include_definition(value_type, type)
      {%
        value_type = value_type.resolve
        type = type.resolve
        is_root = type.superclass.name == "Optarg::Definitions::Base"
        superlocal = type.superclass.name.split("::").last.id
        supertyped = "#{type.superclass}::Typed".id
      %}

      {% if is_root %}
        alias Typed = ::{{value_type}}

        abstract class Validation < ::Optarg::ValueValidation
          macro inherited
            \{%
              is_root = @type.superclass.name == "{{type}}::Validation"
              local = @type.name.split("::").last.id
              snake = local.underscore.id
              validator = "validate_#{snake}".id
              constructor = "new_#{snake}_validation".id
            %}\

            \{% if is_root %}
              def new_error(parser, df, message)
                Error.new(parser, df, self, message)
              end

              # :nodoc:
              class Error < ::Optarg::ValidationError
                getter definition : ::{{type}}
                getter validation : ::\{{@type}}

                def initialize(parser, @definition, @validation, message)
                  super parser, message
                end
              end

              def validate(parser, df)
                unless valid?(parser, df)
                  message = df.validation_error_message_for_\{{snake}}(parser, self)
                  raise new_error(parser, df, message)
                end
              end

              class ::{{type}}
                def \{{constructor}}(*args)
                  Validations::\{{local}}.new(*args)
                end

                def \{{validator}}(parser, *args)
                  ::{{type}}::Validations::\{{local}}.new(*args).validate(parser, self)
                end
              end
            \{% end %}
          end
        end
      {% end %}
    end
  end
end
