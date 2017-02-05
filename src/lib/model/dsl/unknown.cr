module Optarg
  class Model
    # Defines an unknown model item.
    macro unknown(metadata = nil)
      %unknown = ::Optarg::Definitions::Unknown.new(metadata: {{metadata}})
      @@__klass.definitions << %unknown
    end
  end
end
