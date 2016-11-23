module Optarg
  class DefinitionSet
    def initialize(@superset)
      inherit
    end

    def inherit
      if superset?
        superset.all.each{|kv| self << kv[1]}
      end
    end

    @superset : DefinitionSet?
    def superset?
      @superset
    end

    def superset
      @superset.as(DefinitionSet)
    end

    def root?
      @superset.nil?
    end

    @root : DefinitionSet?
    def root
      @root ||= root? ? self : superset.root
    end

    getter options = {} of String => Definitions::Option
    getter arguments = {} of String => Definitions::Argument
    getter handlers = {} of String => Definitions::Handler
    getter terminators = {} of String => Definitions::Terminator

    def <<(df : Definitions::Option)
      [
        all, options,
        options_and_arguments,
        option_visitors,
        concatenation_visitors,
        value_fallbackers,
        value_validators
      ].each do |i|
        i[df.key] = df
      end
    end

    def <<(df : Definitions::Argument)
      [
        all, arguments,
        options_and_arguments,
        value_fallbackers,
        value_validators
      ].each do |i|
        i[df.key] = df
      end
      argument_values << df
    end

    def <<(df : Definitions::Handler)
      [
        all, handlers,
        option_visitors,
        concatenation_visitors
      ].each do |i|
        i[df.key] = df
      end
    end

    def <<(df : Definitions::Terminator)
      [
        all, terminators
      ].each do |i|
        i[df.key] = df
      end
    end

    getter all = {} of String => Definitions::Base
    getter options_and_arguments = {} of String => (Definitions::Option | Definitions::Argument)
    getter option_visitors = {} of String => DefinitionMixins::Visit
    getter concatenation_visitors = {} of String => DefinitionMixins::VisitConcatenated
    getter value_fallbackers = {} of String => DefinitionMixins::FallbackValue
    getter value_validators = {} of String => DefinitionMixins::ValidateValue
    getter argument_values = [] of Definitions::Argument
  end
end
