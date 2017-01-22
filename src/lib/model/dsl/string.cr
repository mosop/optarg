module Optarg
  class Model
    # Defines a String option model item.
    macro string(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil, _mixin = nil, &block)
      __define_static_value :option, :nilable, ::Optarg::Definitions::StringOption, {{names}}, nil, {{_mixin}} do |klass|
        option = klass.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}}, required: {{required}}, any_of: {{any_of}}, complete: {{complete}})
        @@__klass.definitions << option
        {% if block %}
          __with_definition(option) {{block}}
        {% end %}
      end
    end
  end
end
