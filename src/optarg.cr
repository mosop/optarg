require "./optarg/*"
require "./optarg/option_mixins/*"

module Optarg
  macro define_option_type(type)
    {%
      snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
      attribute_name = "#{snake.id}_options"
      variable_name = "@#{attribute_name.id}"
    %}

    class ::Optarg::OptionValueList
      {{variable_name.id}} = ::Hash(::String, ::{{type.id}}).new
      getter :{{attribute_name.id}}
    end
  end

  macro define_array_option_type(type)
    {%
      snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
      attribute_name = "#{snake.id}_array_options"
      variable_name = "@#{attribute_name.id}"
    %}

    class ::Optarg::OptionValueList
      {{variable_name.id}} = ::Hash(::String, ::Array(::{{type.id}})).new
      getter :{{attribute_name.id}}
    end
  end
end

Optarg.define_option_type ::String
Optarg.define_option_type ::Bool
Optarg.define_array_option_type ::String
