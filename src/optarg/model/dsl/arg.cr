module Optarg
  class Model
    macro arg(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil, _mixin = nil, &block)
      define_static_value :argument, :nilable, ::Optarg::Definitions::StringArgument, {{names}}, nil, {{_mixin}} do
        arg = klass.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, required: {{required}}, default: {{default}}, any_of: {{any_of}}, complete: {{complete}})
        definitions << arg
        {% if block %}
          Class.instance.with_definition(option) {{block}}
        {% end %}
      end
    end
  end
end
