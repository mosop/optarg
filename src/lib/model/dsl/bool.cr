module Optarg
  class Model
    # Defines a Bool option model item.
    macro bool(names, metadata = nil, stop = nil, default = nil, not = nil, _mixin = nil, &block)
      __define_static_value :option, :predicate, ::Optarg::Definitions::BoolOption, {{names}}, nil, {{_mixin}} do  |klass|
        option = klass.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}})
        @@__klass.definitions << option
        {% if not %}
          not = ::Optarg::Definitions::NotOption.new({{not}}, option, metadata: nil, stop: {{stop}})
          @@__klass.definitions << not
        {% end %}
        {% if block %}
          __with_definition(option) {{block}}
        {% end %}
      end
    end
  end
end
