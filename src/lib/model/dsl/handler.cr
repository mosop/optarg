module Optarg
  class Model
    # Defines a handler model item.
    macro on(names, metadata = nil, stop = nil, &block)
      __define_static_handler nil, {{names}} {{block}}
      %handler = __create_static_handler({{names}}, metadata: {{metadata}}, stop: {{stop}})
      @@__klass.definitions << %handler
    end
  end
end
