module Optarg
  class Model
    macro __define_argument(name)
      {%
        upcase = name.upcase
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

          def as_data(data)
            data.as?(::{{@type.id}})
          end
        end
      end

      def {{method_name.id}}
        @__arguments[{{upcase}}]
      end

      def {{method_name.id}}?
        @__arguments[{{upcase}}]?
      end
    end

    macro __add_argument(name, metadata = nil, required = nil)
      {%
        upcase = name.upcase
        method_name = name.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
        class_name = "Argument_" + method_name
      %}

      %arg = Arguments::{{class_name.id}}.new({{upcase}}, metadata: {{metadata}}, required: {{required}})
      @@__self_arguments[%arg.key] = %arg
    end

    macro arg(name, metadata = nil, required = nil)
      __define_argument {{name}}
      __add_argument {{name}}, {{metadata}}, {{required}}
    end
  end
end
