module Optarg
  class Model
    macro __option_metadata_class_of(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        class_name = "Option_" + names[0].split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
      %}

      Options::{{class_name.id}}::Metadata
    end

    macro __argument_metadata_class_of(name)
      {%
        class_name = "Argument_" + name.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
      %}

      Arguments::{{class_name.id}}::Metadata
    end

    macro __handler_metadata_class_of(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        class_name = "Handler_" + names[0].split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
      %}

      Handlers::{{class_name.id}}::Metadata
    end
  end
end
