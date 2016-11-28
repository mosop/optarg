module Optarg
  class Model
    macro define_static_option(type, metaclass, names, value_key)
      {%
        metaclass = metaclass.resolve
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        value_key = value_key || names[0]
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        options_reserved = (::Optarg::OptionValueContainer.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
      %}

      {% for method_name, index in method_names %}
        class OptionValueContainer
          {% if type == :predicate %}
            {% unless options_reserved.includes?("#{method_name.id}?".id) %}
              def {{method_name.id}}?
                !!self[::{{metaclass}}::Typed::TYPE][{{value_key}}]?
              end
            {% end %}
          {% elsif type == :nilable %}
            {% unless options_reserved.includes?(method_name.id) %}
              def {{method_name.id}}
                self[::{{metaclass}}::Typed::TYPE][{{value_key}}]
              end
            {% end %}

            {% unless options_reserved.includes?("#{method_name.id}?".id) %}
              def {{method_name.id}}?
                self[::{{metaclass}}::Typed::TYPE][{{value_key}}]?
              end
            {% end %}
          {% end %}
        end

        {% if type == :predicate %}
          {% unless model_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              !!__options[::{{metaclass}}::Typed::TYPE][{{value_key}}]?
            end
          {% end %}
        {% elsif type == :nilable %}
          {% unless model_reserved.includes?(method_name.id) %}
            def {{method_name.id}}
              __options[::{{metaclass}}::Typed::TYPE][{{value_key}}]
            end
          {% end %}

          {% unless model_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              __options[::{{metaclass}}::Typed::TYPE][{{value_key}}]?
            end
          {% end %}
        {% end %}
      {% end %}
    end
  end
end
