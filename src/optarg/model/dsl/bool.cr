module Optarg
  class Model
    macro __define_bool_option(names, default = nil, not = %w())
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        not = [not] unless not.class_name == "ArrayLiteral"
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        options_reserved = (::Optarg::OptionValueList.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
      %}

      __define_hashed_value_option ::Bool, ::Optarg::OptionMixins::Bool, {{names}}

      {% for method_name, index in method_names %}
        class OptionValueList
          {% unless options_reserved.includes?("#{method_name.id}?".id) %}
            def {{method_name.id}}?
              !!bool_options[{{names[0]}}]?
            end
          {% end %}
        end

        {% unless model_reserved.includes?("#{method_name.id}?".id) %}
          def {{method_name.id}}?
            !!__options.bool_options[{{names[0]}}]?
          end
        {% end %}
      {% end %}
    end

    macro __add_bool_option(names, metadata = nil, default = nil, not = nil, group = nil, stop = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        not = [not] if not && not.class_name != "ArrayLiteral"
        class_name = "Option_" + method_names[0]
      %}

      %option = Options::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, default: {{default}}, not: {{not}}, group: {{group}}, stop: {{stop}})
      @@__self_options[%option.key] = %option
    end

    macro bool(names, metadata = nil, default = nil, not = nil, group = nil, stop = nil)
      __define_bool_option {{names}}
      __add_bool_option {{names}}, {{metadata}}, {{default}}, {{not}}, {{group}}, {{stop}}
    end
  end
end
