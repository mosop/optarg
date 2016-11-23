module Optarg
  class Model
    macro terminator(names, metadata = nil)
      %term = ::Optarg::Definitions::Terminator.new({{names}}, metadata: {{metadata}})
      definitions << %term
    end
  end
end
