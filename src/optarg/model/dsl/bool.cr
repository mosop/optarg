module Optarg
  class Model
    macro bool(names, metadata = nil, stop = nil, default = nil, not = nil)
      define_static_option :predicate, ::Optarg::Definitions::BoolOption, {{names}}
      %option = ::Optarg::Definitions::BoolOption.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}}, not: {{not}})
      definitions << %option
    end
  end
end
