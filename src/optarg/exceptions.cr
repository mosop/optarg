module Optarg
  class UnknownOption < ::Exception
    def initialize(message)
      super "Unknown option: #{message}"
    end
  end

  class MissingValue < ::Exception
    def initialize(message)
      super "Missing value: #{message}"
    end
  end

  class UnsupportedConcatenation < ::Exception
    def initialize(message)
      super "Unsupporeted concatenation: #{message}"
    end
  end
end
