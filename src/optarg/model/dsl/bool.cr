module Optarg
  class Model
    macro bool(names, metadata = nil, stop = nil, default = nil, not = nil, _mixin = nil, &block)
      define_static_option :predicate, ::Optarg::Definitions::BoolOption, {{names}}, nil, {{_mixin}} do
        option = new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}})
        model.definitions << option
        {% if not %}
          not = Class::Not.new({{not}}, option, metadata: nil, stop: {{stop}})
          model.definitions << not
        {% end %}
        {% if block %}
          option.tap {{block}}
        {% end %}
      end
    end
  end
end
