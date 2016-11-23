module Optarg
  class Model
    macro define_static_option(type, metaclass, names)
      {%
        metaclass = metaclass.resolve
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        options_reserved = (::Optarg::OptionValueContainer.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
      %}

      {% for method_name, index in method_names %}
        class OptionValueContainer
          {% if type == :predicate %}
            {% unless options_reserved.includes?("#{method_name.id}?".id) %}
              def {{method_name.id}}?
                !!self[::{{metaclass}}::Typed::TYPE][{{names[0]}}]?
              end
            {% end %}
          {% else %}
            {% unless options_reserved.includes?(method_name.id) %}
              def {{method_name.id}}
                self[::{{metaclass}}::Typed::TYPE][{{names[0]}}]
              end
            {% end %}

            {% unless options_reserved.includes?("#{method_name.id}?".id) %}
              def {{method_name.id}}?
                self[::{{metaclass}}::Typed::TYPE][{{names[0]}}]?
              end
            {% end %}
          {% end %}
        end

        {% if type == :predicate %}
          {% unless model_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              !!__options[::{{metaclass}}::Typed::TYPE][{{names[0]}}]?
            end
          {% end %}
        {% else %}
          {% unless model_reserved.includes?(method_name.id) %}
            def {{method_name.id}}
              __options[::{{metaclass}}::Typed::TYPE][{{names[0]}}]
            end
          {% end %}

          {% unless model_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              __options[::{{metaclass}}::Typed::TYPE][{{names[0]}}]?
            end
          {% end %}
        {% end %}
      {% end %}
    end
  end
end
