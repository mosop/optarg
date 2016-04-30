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
end