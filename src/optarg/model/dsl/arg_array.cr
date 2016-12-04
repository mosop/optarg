module Optarg
  class Model
    macro arg_array(names, metadata = nil, default = nil, min = nil, any_item_of = nil, complete = nil, _mixin = nil, &block)
      define_static_argument :nilable, ::Optarg::Definitions::StringArrayArgument, {{names}}, nil, {{_mixin}} do
        option = new({{names}}, metadata: {{metadata}}, default: {{default}}, min: {{min}}, any_item_of: {{any_item_of}}, complete: {{complete}})
        model.definitions << option
        {% if block %}
          option.tap {{block}}
        {% end %}
      end
    end
  end
end
