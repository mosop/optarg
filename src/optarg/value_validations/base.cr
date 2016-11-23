module Optarg::ValueValidations
  abstract class Base(T)
    macro __concrete
      {%
        type_var = @type.superclass.type_vars[0].id
        is_generic = type_var == "T".id
      %}
      {% if !@type.abstract? && !is_generic %}
        alias DEFINITION_TYPE = {{type_var}}
        module Validate
          abstract def validate(parser, df : DEFINITION_TYPE)
        end
        include Validate
      {% end %}
    end

    macro inherited
      __concrete
    end
  end
end
