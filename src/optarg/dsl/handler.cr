module Optarg
  class Model
    macro __define_handler(names, &block)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Handler_" + method_names[0]
      %}

      def __handle_{{method_names[0].id}}
        __yield {{block}}
      end

      module Handlers
        class {{class_name.id}} < ::{{@type.id}}::Handler
          class Metadata < ::{{@type.id}}::Handler::Metadata
          end

          def metadata
            @metadata as Metadata
          end

          def parse(args, data)
            data.__handle_{{method_names[0].id}} if data.responds_to?(:__handle_{{method_names[0].id}})
          end
        end
      end
    end

    macro __add_handler(names, metadata = nil, group = nil, stop = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Handler_" + method_names[0]
      %}

      %handler = Handlers::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, group: {{group}}, stop: {{stop}})
      @@__self_handlers[%handler.key] = %handler
    end

    macro on(names, metadata = nil, group = nil, stop = nil, &block)
      __define_handler {{names}} {{block}}
      __add_handler {{names}}, {{metadata}}, {{group}}, {{stop}}
    end
  end
end
