module Optarg
  class Model
    macro __define_argument(name)
      {%
        method_name = name.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
        class_name = "Argument_" + method_name
        model_reserved = (::Optarg::Model.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
        args_reserved = (::Optarg::ArgumentValueList.methods + ::Reference.methods + ::Object.methods).map{|i| i.name}
      %}

      module Arguments
        class {{class_name.id}} < ::{{@type.id}}::Argument
          class Metadata < ::{{@type.id}}::Argument::Metadata
          end

          def metadata
            @metadata.as(Metadata)
          end

          def as_data?(data)
            data.as?(::{{@type.id}})
          end

          def with_data(data)
            yield data if data = as_data?(data)
          end
        end
      end

      class ArgumentValueList
        {% unless args_reserved.includes?(method_name.id) %}
          def {{method_name.id}}
            __named[{{name}}]
          end
        {% end %}

        {% unless args_reserved.includes?("#{method_name.id}?".id) %}
          def {{method_name.id}}?
            __named[{{name}}]?
          end
        {% end %}
      end

      {% unless model_reserved.includes?(method_name.id) %}
        def {{method_name.id}}
          __args.__named[{{name}}]
        end
      {% end %}

      {% unless model_reserved.includes?("#{method_name.id}?".id) %}
        def {{method_name.id}}?
          __args.__named[{{name}}]?
        end
      {% end %}
    end

    macro __add_argument(name, metadata = nil, required = nil, group = nil, stop = nil, default = nil)
      {%
        method_name = name.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
        class_name = "Argument_" + method_name
      %}

      %arg = Arguments::{{class_name.id}}.new({{name}}, metadata: {{metadata}}, required: {{required}}, group: {{group}}, stop: {{stop}}, default: {{default}})
      @@__self_arguments[%arg.key] = %arg
    end

    macro arg(name, metadata = nil, required = nil, group = nil, stop = nil, default = nil)
      __define_argument {{name}}
      __add_argument {{name}}, {{metadata}}, {{required}}, {{group}}, {{stop}}, {{default}}
    end
  end
end
