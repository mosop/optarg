module Optarg::Definitions
  class Unknown < Base
    def initialize(metadata = nil)
      super "@unknown", metadata: metadata, unknown: true
    end

    def completion_length(gen)
      1
    end

    def completion_max_occurs(gen)
      1
    end
  end
end
