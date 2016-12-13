module Optarg
  class Model
    macro arg_array(names, metadata = nil, default = nil, min = nil, any_item_of = nil, complete = nil, _mixin = nil, &block)
      define_static_value :argument, :nilable, ::Optarg::Definitions::StringArrayArgument, {{names}}, nil, {{_mixin}} do
        option = klass.new({{names}}, metadata: {{metadata}}, default: {{default}}, min: {{min}}, any_item_of: {{any_item_of}}, complete: {{complete}})
        definitions << option
        {% if block %}
          Class.instance.with_definition(option) {{block}}
        {% end %}
      end
    end
  end
end
