module Optarg
  class Model
    macro string(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil, complete = nil, _mixin = nil, &block)
      define_static_option :nilable, ::Optarg::Definitions::StringOption, {{names}}, nil, {{_mixin}} do
        option = new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}}, required: {{required}}, any_of: {{any_of}}, complete: {{complete}})
        model.definitions << option
        {% if block %}
          option.tap {{block}}
        {% end %}
      end
    end
  end
end
