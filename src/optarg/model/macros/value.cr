module Optarg
  class Model
    macro define_static_value(kind, access_type, metaclass, names, value_key, _mixin, &block)
      {%
        kind = kind.id
        metaclass = metaclass.resolve
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_").id}
        value_key = value_key || names[0]
        key = names[0].id
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        definer = "__define_static_#{kind}__#{method_names[0]}".id
      %}

      {% if kind == :argument %}
        {%
          container_class = "ArgumentValueContainer".id
          container_reserved = (::Optarg::ArgumentValueContainer.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
          container_method = "__args".id
          df_getter = "#{method_names[0]}_arg".id
        %}
      {% else %}
        {%
          container_class = "OptionValueContainer".id
          container_reserved = (::Optarg::OptionValueContainer.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
          container_method = "__options".id
          df_getter = "#{method_names[0]}_option".id
        %}
      {% end %}

      {% for method_name, index in method_names %}
        class {{container_class}}
          {% if access_type == :predicate %}
            {% unless container_reserved.includes?("#{method_name}?".id) %}
              def {{method_name}}?
                !!self[::{{metaclass}}::Typed::Type][{{value_key}}]?
              end
            {% end %}
          {% elsif access_type == :nilable %}
            {% unless container_reserved.includes?(method_name) %}
              def {{method_name}}
                self[::{{metaclass}}::Typed::Type][{{value_key}}]
              end
            {% end %}

            {% unless container_reserved.includes?("#{method_name}?".id) %}
              def {{method_name}}?
                self[::{{metaclass}}::Typed::Type][{{value_key}}]?
              end
            {% end %}
          {% end %}
        end

        {% if access_type == :predicate %}
          {% unless model_reserved.includes?("#{method_name}?".id) %}
            def {{method_name}}?
              !!{{container_method}}[::{{metaclass}}::Typed::Type][{{value_key}}]?
            end
          {% end %}
        {% elsif access_type == :nilable %}
          {% unless model_reserved.includes?(method_name) %}
            def {{method_name}}
              {{container_method}}[::{{metaclass}}::Typed::Type][{{value_key}}]
            end
          {% end %}

          {% unless model_reserved.includes?("#{method_name}?".id) %}
            def {{method_name}}?
              {{container_method}}[::{{metaclass}}::Typed::Type][{{value_key}}]?
            end
          {% end %}
        {% end %}
      {% end %}

      class Class
        def {{definer}}(klass)
          {{block.body}}
        end
        instance.{{definer}} ::{{metaclass}}
      end
    end
  end
end
