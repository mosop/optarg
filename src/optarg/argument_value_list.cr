module Optarg
  class ArgumentValueList
    macro method_missing(call)
      {%
        send = call.name =~ /^\w/ ? ".#{call.name.id}" : " #{call.name.id}"
      %}

      @__array{{send.id}} {{call.args.map{|i| i.id}.join(", ").id}} {{call.block}}
    end

    @__array = %w()

    def ==(other)
      @__array == (other)
    end
  end
end
