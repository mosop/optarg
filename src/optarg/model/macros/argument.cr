module Optarg
  class Model
    macro define_static_argument(type, metaclass, names, value_key, _mixin, &block)
      {%
        metaclass = metaclass.resolve
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        value_key = value_key || names[0]
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        args_reserved = (::Optarg::ArgumentValueContainer.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        class_name = "Argument_#{method_names[0].id}".id
      %}

      {% for method_name, index in method_names %}
        class ArgumentValueContainer
          {% unless args_reserved.includes?(method_name.id) %}
            def {{method_name.id}}
              self[::{{@type}}::{{class_name}}::Typed::Type][{{value_key}}]
            end
          {% end %}

          {% unless args_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              self[::{{@type}}::{{class_name}}::Typed::Type][{{value_key}}]?
            end
          {% end %}
        end

        {% unless model_reserved.includes?(method_name.id) %}
          def {{method_name.id}}
            __args[::{{@type}}::{{class_name}}::Typed::Type][{{value_key}}]
          end
        {% end %}

        {% unless model_reserved.includes?("#{method_name.id}?".id) %}
          def {{method_name.id}}?
            __args[::{{@type}}::{{class_name}}::Typed::Type][{{value_key}}]?
          end
        {% end %}
      {% end %}

      class {{class_name}} < {{metaclass}}
        alias Class = {{class_name}}
        alias Model = ::{{@type}}

        def self.model
          ::{{@type}}::Class.instance
        end

        {% if _mixin %}
          include {{_mixin}}
        {% end %}

        def self.define_static
          {{block.body}}
        end

        define_static
      end
    end
  end
end
