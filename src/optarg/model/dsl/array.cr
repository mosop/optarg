module Optarg
  class Model
    macro array(names, metadata = nil, default = nil, min = nil)
      define_static_option :nilable, ::Optarg::Definitions::StringArrayOption, {{names}}, nil
      %option = ::Optarg::Definitions::StringArrayOption.new({{names}}, metadata: {{metadata}}, default: {{default}}, min: {{min}})
      definitions << %option
    end
  end
end
