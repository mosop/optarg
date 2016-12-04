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

            abstract class ValidationContext < ::Optarg::ValueValidationContext
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
        is_static = type.superclass.superclass.superclass.name == "Optarg::Definitions::Base"
        superlocal = type.superclass.name.split("::").last.id
        supertyped = "#{type.superclass}::Typed".id
      %}

      {% if is_root || is_static %}
        class Typed < ::{{supertyped}}
        end

        class Typed::Value < ::{{supertyped}}::Value
        end

        class Typed::ValueHash < ::{{supertyped}}::ValueHash
        end
      {% end %}

      {% if is_root %}
        class Typed::ValidationContextCallback
          ::Callback.enable
           define_callback_group :validate, proc_type: ::Proc(::{{type}}::Typed::ValidationContext, ::Nil)
        end

        abstract class Typed::Validation < ::{{supertyped}}::Validation
          macro inherited
            \{%
              is_root = @type.superclass.superclass.superclass.name == "Optarg::ValueValidation"
              definition = @type.name.split("::")[0..-3].join("::").id
              local = @type.name.split("::").last.id
              snake = local.underscore.id
            %}\

            \{% if is_root %}
              def new_error(parser, df, message)
                Error.new(parser, df, self, message)
              end

              class Error < ::Optarg::ValidationError
                getter definition : ::\{{definition}}
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
            \{% end %}
          end
        end
      {% end %}

      {% if is_static %}
        @validation_context_callback = Typed::ValidationContextCallback.new

        class Typed::ValidationContext < ::{{supertyped}}::ValidationContext
          alias Model = ::{{type}}::Model
          alias Parser = Model::Parser
          alias Definition = ::{{type}}

          getter parser : Parser
          getter definition : Definition

          def initialize(parser, @definition)
            @parser = parser.as(Parser)
          end
        end

        def validate(parser)
          validations.each{|i| i.validate(parser, self)}
          context = Typed::ValidationContext.new(parser, self)
          @validation_context_callback.run_callbacks_for_validate(context) {}
        end

        def on_validate(&block : Typed::ValidationContext -> _)
          @validation_context_callback.on_validate do |cb, context|
            block.call context.as(Typed::ValidationContext)
          end
        end

        ::Optarg::ValueTypes::Base.__define_validation_methods ::{{type}}, ::{{type}}::Validations
      {% end %}
    end

    macro __define_validation_methods(type, mod)
      {%
        type = type.resolve
        mod = mod.resolve
      %}
      {% for e, i in mod.constants %}
        ::Optarg::ValueTypes::Base.__define_validation_method ::{{type}}, ::{{mod}}::{{e}}, {{e}}
      {% end %}
    end

    macro __define_validation_method(type, v, local)
      {%
        type = type.resolve
        v = v.resolve
      %}
      {% if v < ::Optarg::ValueValidation %}
        {%
          snake = local.id.underscore.id
          mod = "#{local}Module".id
          validate = "validate_#{snake}".id
          constructor = "new_#{snake}_validation".id
        %}

        def {{constructor}}(*args)
          Validations::{{local}}.new(*args)
        end

        class Typed::ValidationContext
          module {{mod}}
            def {{validate}}(*args)
              ::{{type}}::Validations::{{local}}.new(*args).validate(parser, definition)
            end
          end
          include {{mod}}
        end
      {% end %}
    end
  end
end
