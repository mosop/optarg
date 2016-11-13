module Optarg
  abstract class ArgumentValueContainer
    macro method_missing(call)
      {%
        args = call.args.map{|i| i.id}.join(", ")
      %}

      {% if call.name == "[]" %}
        @__values[{{args.id}}]
      {% elsif call.name == "[]?" %}
        @__values[{{args.id}}]?
      {% elsif call.name == "[]=" %}
        @__values[{{call.args[0..-2].map{|i| i.id}.join(", ").id}}] = {{call.args.last.id}}
      {% elsif call.name =~ /^\w/ %}
        @__values.{{call}}
      {% else %}
        @__values {{call.name.id}} {{args.id}}
      {% end %}
    end

    getter __values = %w()
    getter __nameless = %w()
    getter __named = {} of String => String

    def ==(other)
      @__values == other
    end

    def inspect
      @__values.inspect
    end
  end
end
