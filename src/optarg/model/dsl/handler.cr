module Optarg
  class Model
    macro on(names, metadata = nil, stop = nil, &block)
      define_static_handler nil, {{names}} {{block}}
      %handler = create_static_handler({{names}}, metadata: {{metadata}}, stop: {{stop}})
      definitions << %handler
    end
  end
end
