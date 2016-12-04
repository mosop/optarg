module Optarg
  class Model
    macro arg(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil, _mixin = nil, &block)
      define_static_argument :nilable, ::Optarg::Definitions::StringArgument, {{names}}, nil, {{_mixin}} do
        arg = new({{names}}, metadata: {{metadata}}, stop: {{stop}}, required: {{required}}, default: {{default}}, any_of: {{any_of}}, complete: {{complete}})
        model.definitions << arg
        {% if block %}
          option.tap {{block}}
        {% end %}
      end
    end
  end
end
