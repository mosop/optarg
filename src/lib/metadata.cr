module Optarg
  class Metadata
    @definition : Definitions::Base?
    def definition=(value)
      @definition = value
    end

    def definition
      @definition.as(Definitions::Base)
    end

    getter tags = %w()

    def display_name
      definition.key
    end
  end
end
