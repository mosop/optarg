module Optarg
  class ParsingError < Exception
    # :nodoc:
    getter parser : Parser

    # :nodoc:
    def initialize(@parser, message)
      super message
    end
  end

  # :nodoc:
  class UnknownOption < ParsingError
    def initialize(parser, name)
      super parser, "The #{name} option is unknown."
    end
  end

  # :nodoc:
  class MissingValue < ParsingError
    getter option : DefinitionMixins::Option

    def initialize(parser, @option, name)
      super parser, "The #{name} option has no value."
    end
  end

  # :nodoc:
  class UnsupportedConcatenation < ParsingError
    getter option : DefinitionMixins::Option

    def initialize(parser, option : DefinitionMixins::Option)
      @option = option
      super parser, "The #{option.metadata.display_name} option can not be concatenated."
    end
  end

  class ValidationError < ParsingError
    # :nodoc:
    def initialize(parser, message)
      super parser, message
    end
  end
end
