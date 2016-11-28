module Optarg
  class Model
    macro bool(names, metadata = nil, stop = nil, default = nil, not = nil)
      define_static_option :predicate, ::Optarg::Definitions::BoolOption, {{names}}, nil
      %option = ::Optarg::Definitions::BoolOption.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}})
      definitions << %option

      {% if not %}
        {%
          names = [names] unless names.class_name == "ArrayLiteral"
        %}
        %not = ::Optarg::Definitions::NotOption.new({{not}}, {{names[0]}}, metadata: nil, stop: {{stop}})
        definitions << %not
      {% end %}
    end
  end
end
