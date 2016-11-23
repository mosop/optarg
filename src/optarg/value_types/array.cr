require "./base"

module Optarg::ValueTypes
  abstract class Array(T) < Base(Array(T))
    macro inherited
      {% type = @type.superclass.type_vars[0].id %}
      alias TYPE = ::Array(::{{type}})
      alias ELEMENT_TYPE = ::{{type}}

      macro __concrete_array
        class ElementValue < ::Optarg::ValueTypes::{{type}}::Value
        end
      end
    end
  end
end
