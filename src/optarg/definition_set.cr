module Optarg
  class DefinitionSet
    getter model : ModelClass

    def initialize(@model)
      inherit
    end

    def inherit
      if model.supermodel?
        model.supermodel.definitions.all.each{|kv| self << kv[1].subclassify(model)}
      end
    end

    macro __set(types, list, array = nil)
      {%
        types = [types] unless types.class_name == "ArrayLiteral"
        a = %w()
      %}
      {% for e, i in types %}
        {% if i == 0 %}
          {%
            a << "if o = df.as?(#{e})"
          %}
        {% else %}
          {%
            a << "elsif o = df.as?(#{e})"
          %}
        {% end %}
        {%
          a << "#{list}[o.key] = o"
          a << "#{array} << o" if array
        %}
      {% end %}
      {%
        a << "end"
      %}
      {{a.join("\n").id}}
    end

    def <<(df : Definitions::Base)
      all[df.key] = df
      __set DefinitionMixins::Option, options
      __set DefinitionMixins::ValueOption, value_options
      __set DefinitionMixins::Argument, arguments, array: argument_list
      __set Definitions::Handler, handlers
      __set Definitions::Terminator, terminators
      __set DefinitionMixins::Value, values
      __set Definitions::StringArrayArgument, string_array_arguments
    end

    getter all = {} of String => Definitions::Base
    getter arguments = {} of String => DefinitionMixins::Argument
    getter options = {} of String => DefinitionMixins::Option
    getter value_options = {} of String => DefinitionMixins::ValueOption
    getter handlers = {} of String => Definitions::Handler
    getter terminators = {} of String => Definitions::Terminator
    getter values = {} of String => DefinitionMixins::Value
    getter string_array_arguments = {} of String => Definitions::StringArrayArgument

    getter argument_list = [] of DefinitionMixins::Argument
  end
end
