module Optarg
  class Model
    macro arg(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil)
      define_static_argument :nilable, ::Optarg::Definitions::StringArgument, {{names}}
      %arg = ::Optarg::Definitions::StringArgument.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, required: {{required}}, default: {{default}}, any_of: {{any_of}})
      definitions << %arg
    end
  end
end
