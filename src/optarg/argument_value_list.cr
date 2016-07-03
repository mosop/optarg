module Optarg
  abstract class ArgumentValueList
    macro method_missing(call)
      {%
        args = call.args.map{|i| i.id}.join(", ")
      %}

      {% if call.name == "[]" %}
        @__array[{{args.id}}]
      {% elsif call.name == "[]=" %}
        @__array[{{call.args[0..-2].map{|i| i.id}.join(", ").id}}] = {{call.args.last.id}}
      {% elsif call.name =~ /^\w/ %}
        @__array.{{call}}
      {% else %}
        @__array {{call.name.id}} {{args.id}}
      {% end %}
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
