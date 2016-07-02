module Optarg
  abstract class ArgumentValueList
    macro method_missing(call)
      {%
        send = call.name =~ /^\w/ ? ".#{call.name.id}" : " #{call.name.id}"
      %}

      @__array{{send.id}} {{call.args.map{|i| i.id}.join(", ").id}} {{call.block}}
    end

    @__array = %w()
    @__nameless = %w()
    getter :__nameless
    @__named = {} of String => String
    getter :__named

    def ==(other)
      @__array == (other)
    end

    def inspect
      @__array.inspect
    end

    def nameless
      __nameless
    end

    def named
      __named
    end
  end
end
