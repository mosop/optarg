module Optarg
  class Completion
    getter type : Symbol
    getter model : ModelClass

    def initialize(@type, @model)
    end

    def generator_class
      case type
      when :bash
        CompletionGenerators::Bash
      when :zsh
        CompletionGenerators::Zsh
      else
        raise "Unknown type: #{type}"
      end
    end

    def new_generator(prefix : String)
      generator_class.new(self, prefix)
    end

    def new_generator(previous : CompletionGenerators::Base)
      generator_class.new(previous, self)
    end
  end
end
