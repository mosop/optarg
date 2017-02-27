module Optarg
  class Model
    # Defines an Array(String) option model item.
    macro array(names, metadata = nil, default = nil, min = nil, any_item_of = nil, complete = nil, _mixin = nil, &block)
      __define_static_value :option, :array, ::Optarg::Definitions::StringArrayOption, {{names}}, nil, {{_mixin}} do |klass|
        option = klass.new({{names}}, metadata: {{metadata}}, default: {{default}}, min: {{min}}, any_item_of: {{any_item_of}}, complete: {{complete}})
        @@__klass.definitions << option
        {% if block %}
          __with_definition(option) {{block}}
        {% end %}
      end
    end
  end
end
