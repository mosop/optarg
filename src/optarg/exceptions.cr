module Optarg
  class ParsingError < ::Exception
  end

  class UnknownOption < ParsingError
    def initialize(key)
      super "The #{key} option is unknown."
    end
  end

  class MissingValue < ParsingError
    def initialize(key)
      super "The #{key} option has no value."
    end
  end

  class UnsupportedConcatenation < ParsingError
    def initialize(key)
      super "The #{key} option can not be concatenated."
    end
  end

  abstract class ValidationError < ParsingError
  end

  class RequiredOptionError < ValidationError
    def initialize(key)
      super "The #{key} option is required."
    end
  end

  class RequiredArgumentError < ValidationError
    getter argument : Argument

    def initialize(@argument)
      super "The #{@argument.display_name} argument is required."
    end
  end

  class MinimumLengthError < ValidationError
    def initialize(key, expected, actual)
      super "The #{key} option's length is #{actual}, but #{expected} or more is expected."
    end
  end
end
