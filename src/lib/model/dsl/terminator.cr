module Optarg
  class Model
    # Defines a terminator model item.
    macro terminator(names, metadata = nil)
      %term = ::Optarg::Definitions::Terminator.new({{names}}, metadata: {{metadata}})
      @@__klass.definitions << %term
    end
  end
end
