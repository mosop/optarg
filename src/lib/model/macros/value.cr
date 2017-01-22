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
        type_id = @type.name.split("(")[0].split("::").join("_").id
        snake_type_id = type_id.underscore
        definer = "#{snake_type_id}__define_static_#{kind}__#{method_names[0]}".id
      %}

      {% if kind == :argument %}
        {%
          container_method = "self".id
          df_getter = "#{method_names[0]}_arg".id
        %}
      {% else %}
        {%
          container_method = "self".id
          df_getter = "#{method_names[0]}_option".id
        %}
      {% end %}

      {% for method_name, index in method_names %}
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


      ::{{@type}}.__with_self(::{{metaclass}}) {{block}}
    end
  end
end
