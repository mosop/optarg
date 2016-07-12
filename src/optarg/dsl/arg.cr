module Optarg
  class Model
    macro __define_argument(name)
      {%
        method_name = name.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
        class_name = "Argument_" + method_name
      %}

      module Arguments
        class {{class_name.id}} < ::{{@type.id}}::Argument
          class Metadata < ::{{@type.id}}::Argument::Metadata
          end

          def metadata
            @metadata as Metadata
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
        def {{method_name.id}}
          __named[{{name}}]
        end

        def {{method_name.id}}?
          __named[{{name}}]?
        end
      end

      def {{method_name.id}}
        __args.{{method_name.id}}
      end

      def {{method_name.id}}?
        __args.{{method_name.id}}?
      end
    end

    macro __add_argument(name, metadata = nil, required = nil, group = nil)
      {%
        method_name = name.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
        class_name = "Argument_" + method_name
      %}

      %arg = Arguments::{{class_name.id}}.new({{name}}, metadata: {{metadata}}, required: {{required}}, group: {{group}})
      @@__self_arguments[%arg.key] = %arg
    end

    macro arg(name, metadata = nil, required = nil, group = nil)
      __define_argument {{name}}
      __add_argument {{name}}, {{metadata}}, {{required}}, {{group}}
    end
  end
end
