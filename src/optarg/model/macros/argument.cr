module Optarg
  class Model
    macro define_static_argument(type, metaclass, names)
      {%
        metaclass = metaclass.resolve
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        args_reserved = (::Optarg::ArgumentValueContainer.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
      %}

      {% for method_name, index in method_names %}
        class ArgumentValueContainer
          {% unless args_reserved.includes?(method_name.id) %}
            def {{method_name.id}}
              __named[{{names[0]}}]
            end
          {% end %}

          {% unless args_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              __named[{{names[0]}}]?
            end
          {% end %}
        end

        {% unless model_reserved.includes?(method_name.id) %}
          def {{method_name.id}}
            __args.__named[{{names[0]}}]
          end
        {% end %}

        {% unless model_reserved.includes?("#{method_name.id}?".id) %}
          def {{method_name.id}}?
            __args.__named[{{names[0]}}]?
          end
        {% end %}
      {% end %}
    end
  end
end
