module Optarg
  class Model
    macro __define_string_option(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
      %}

      __define_hashed_value_container ::String
      __define_hashed_value_option ::String, ::Optarg::OptionMixins::String, {{names}}

      {% for method_name, index in method_names %}
        def {{method_name.id}}
          @__options__string[{{names[0]}}]
        end

        def {{method_name.id}}?
          @__options__string[{{names[0]}}]?
        end
      {% end %}
    end

    macro __add_string_option(names, metadata = nil, default = nil, required = nil, group = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Option_" + method_names[0]
      %}

      %option = Options::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, default: {{default}}, required: {{required}}, group: {{group}})
      @@__self_options[%option.key] = %option
    end

    macro string(names, metadata = nil, default = nil, required = nil, group = nil)
      __define_string_option {{names}}
      __add_string_option {{names}}, {{metadata}}, {{default}}, {{required}}, {{group}}
    end
  end
end
