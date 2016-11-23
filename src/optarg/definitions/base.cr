module Optarg::Definitions
  abstract class Base
    ::Callback.enable
    define_callback_group :before_parse, proc_type: Proc(Optarg::Parser, Nil)
    define_callback_group :after_parse, proc_type: Proc(Optarg::Parser, Nil)

    getter names : Array(String)
    getter metadata : Metadata

    def initialize(names : String | Array(String), metadata = nil, stop = nil, terminate = nil)
      @names = if names.is_a?(String)
        [names]
      else
        names
      end
      @metadata = metadata || Metadata.new
      @stops = !!stop
      @terminates = !!terminate
      @metadata.definition = self
    end

    @stops : Bool
    def stops?
      @stops
    end

    @terminates : Bool
    def terminates?
      @terminates
    end

    def key
      @names[0]
    end

    def matches?(name)
      @names.includes?(name)
    end
  end
end
