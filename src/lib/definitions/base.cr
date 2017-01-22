require "../definition_mixins/completion"

module Optarg::Definitions
  abstract class Base
    include DefinitionMixins::Completion

    getter names : Array(String)
    getter metadata : Metadata

    def initialize(names : String | Array(String), metadata : Metadata? = nil, stop : Bool? = nil, terminate : Bool? = nil, complete : String | Symbol | Array(String) | Nil = nil)
      @names = case names
      when String
        [names]
      else
        names
      end
      @metadata = metadata || Metadata.new
      @metadata.definition = self
      @stops = !!stop
      @terminates = !!terminate
      initialize_completion complete: (complete || "")
    end

    @stops : Bool?
    def stops?
      @stops.as(Bool)
    end

    @terminates : Bool?
    def terminates?
      @terminates.as(Bool)
    end

    def key
      @names[0]
    end

    def matches?(name)
      @names.includes?(name)
    end

    def subclassify(model)
      self
    end

    def initialize_before_parse(parser)
    end

    def initialize_after_parse(parser)
    end
  end
end
