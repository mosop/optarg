module Optarg
  class Model
    macro __define_string_option(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        options_reserved = (::Optarg::OptionValueContainer.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
      %}

      __define_hashed_value_option ::String, ::Optarg::OptionMixins::String, {{names}}

      {% for method_name, index in method_names %}
        class OptionValueContainer
          {% unless options_reserved.includes?(method_name.id) %}
            def {{method_name.id}}
              @__strings[{{names[0]}}]
            end
          {% end %}

          {% unless options_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              @__strings[{{names[0]}}]?
            end
          {% end %}
        end

        {% unless model_reserved.includes?(method_name.id) %}
          def {{method_name.id}}
            __options.__strings[{{names[0]}}]
          end
        {% end %}

        {% unless model_reserved.includes?("#{method_name.id}?".id) %}
          def {{method_name.id}}?
            __options.__strings[{{names[0]}}]?
          end
        {% end %}
      {% end %}
    end

    macro __add_string_option(names, metadata = nil, default = nil, required = nil, group = nil, stop = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Option_" + method_names[0]
      %}

      %option = Options::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, default: {{default}}, required: {{required}}, group: {{group}}, stop: {{stop}})
      @@__self_options[%option.key] = %option
    end

    macro string(names, metadata = nil, default = nil, required = nil, group = nil, stop = nil)
      __define_string_option {{names}}
      __add_string_option {{names}}, {{metadata}}, {{default}}, {{required}}, {{group}}, {{stop}}
    end
  end
end
