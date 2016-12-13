module Optarg
  class Model
    macro string(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil, _mixin = nil, &block)
      define_static_value :option, :nilable, ::Optarg::Definitions::StringOption, {{names}}, nil, {{_mixin}} do
        option = klass.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}}, required: {{required}}, any_of: {{any_of}}, complete: {{complete}})
        definitions << option
        {% if block %}
          Class.instance.with_definition(option) {{block}}
        {% end %}
      end
    end
  end
end
