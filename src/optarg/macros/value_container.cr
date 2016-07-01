module Optarg
  class Model
    macro __define_hashed_value_container(type)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "__options__#{snake.id}"
        variable_name = "@#{attribute_name.id}"
      %}

      {% unless @type.has_attribute?(variable_name) %}
        {{variable_name.id}} = ::Hash(::String, ::{{type.id}}).new
        getter :{{attribute_name.id}}
      {% end %}
    end

    macro __define_hashed_array_value_container(type)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "__array_options__#{snake.id}"
        variable_name = "@#{attribute_name.id}"
      %}

      {% unless @type.has_attribute?(variable_name) %}
        {{variable_name.id}} = ::Hash(::String, ::Array(::{{type.id}})).new
        getter :{{attribute_name.id}}
      {% end %}
    end
  end
end
