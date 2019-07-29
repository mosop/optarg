module Optarg::Definitions
  class Unknown < Base
    def initialize(metadata = nil)
      super "@unknown", metadata: metadata, unknown: true
    end

    def completion_length(gen) : Int32
      1
    end

    def completion_max_occurs(gen) : Int32
      1
    end
  end
end
