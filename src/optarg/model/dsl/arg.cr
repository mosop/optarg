module Optarg
  class Model
    macro arg(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil, _mixin = nil, &block)
      define_static_value :argument, :nilable, ::Optarg::Definitions::StringArgument, {{names}}, nil, {{_mixin}} do |klass|
        arg = klass.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, required: {{required}}, default: {{default}}, any_of: {{any_of}}, complete: {{complete}})
        __definitions << arg
        {% if block %}
          __with_definition(option) {{block}}
        {% end %}
      end
    end
  end
end
