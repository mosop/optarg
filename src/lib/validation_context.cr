module Optarg
  # :nodoc:
  class ValidationContext
    @parser : Parser
    @definition : Definitions::Base

    def initialize(@parser, @definition)
    end

    def validate_element_inclusion(*args)
      df = @definition
      if df.responds_to?(:validate_element_inclusion)
        df.validate_element_inclusion @parser, *args
      end
    end
  end
end
