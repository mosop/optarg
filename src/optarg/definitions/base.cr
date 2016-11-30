require "../definition_mixins/completion"

module Optarg::Definitions
  abstract class Base
    ::Callback.enable
    define_callback_group :before_parse, proc_type: Proc(Optarg::Parser, Nil)
    define_callback_group :after_parse, proc_type: Proc(Optarg::Parser, Nil)

    include DefinitionMixins::Completion

    getter names : Array(String)
    getter metadata : Metadata

    def initialize(names : String | Array(String), metadata : Metadata? = nil, stop : Bool? = nil, terminate : Bool? = nil)
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
  end
end
