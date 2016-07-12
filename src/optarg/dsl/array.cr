module Optarg
  class Model
    macro __define_string_array_option(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
      %}

      __define_hashed_array_value_container ::String
      __define_hashed_array_value_option ::String, ::Optarg::OptionMixins::Array(String), {{names}}

      {% for method_name, index in method_names %}
        def {{method_name.id}}
          @__array_options__string[{{names[0]}}]
        end
      {% end %}
    end

    macro __add_string_array_option(names, metadata = nil, default = nil, min = nil, group = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Option_" + method_names[0]
      %}

      %option = Options::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, default: {{default}}, min: {{min}}, group: {{group}})
      @@__self_options[%option.key] = %option
    end

    macro array(names, metadata = nil, default = nil, min = nil, group = nil)
      __define_string_array_option {{names}}
      __add_string_array_option {{names}}, {{metadata}}, {{default}}, {{min}}, {{group}}
    end
  end
end
