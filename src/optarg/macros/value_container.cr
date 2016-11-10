module Optarg
  class Model
    macro __define_hashed_value_container(type)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "#{snake.id}_options"
        variable_name = "@#{attribute_name.id}"
      %}

      {% unless ::Optarg::Model.has_attribute?(variable_name) %}
        class ::Optarg::Model
          {{variable_name.id}} = ::Hash(::String, ::{{type.id}}).new
          getter :{{attribute_name.id}}
        end
      {% end %}
    end

    macro __define_hashed_array_value_container(type)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "#{snake.id}_array_options"
        variable_name = "@#{attribute_name.id}"
      %}

      {% unless ::Optarg::Model.has_attribute?(variable_name) %}
        class ::Optarg::Model
          {{variable_name.id}} = ::Hash(::String, ::Array(::{{type.id}})).new
          getter :{{attribute_name.id}}
        end
      {% end %}
    end
  end
end
