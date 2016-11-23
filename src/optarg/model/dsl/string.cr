module Optarg
  class Model
    macro string(names, metadata = nil, stop = nil, default = nil, required = nil, any_of = nil)
      define_static_option :nilable, ::Optarg::Definitions::StringOption, {{names}}
      %option = ::Optarg::Definitions::StringOption.new({{names}}, metadata: {{metadata}}, stop: {{stop}}, default: {{default}}, required: {{required}}, any_of: {{any_of}})
      definitions << %option
    end
  end
end
