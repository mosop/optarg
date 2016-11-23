module Optarg
  class Model
    macro define_static_handler(type, names, &block)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        name = method_names[0].id
        df_class = "Handler__#{name}".id
      %}

      def __call_handler_for__{{name}}
        {{block.body}}
      end

      class {{df_class}} < ::Optarg::Definitions::Handler
        def visit(parser)
          if data = parser.data.as?(::{{@type}})
            data.__call_handler_for__{{name}}
            Parser.new_node(parser[0..0], self)
          end
        end

        def visit_concatenated(parser, name)
          visit parser
        end
      end
    end

    macro create_static_handler(names, metadata, stop)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        name = method_names[0].id
        df_class = "Handler__#{name}".id
      %}
      {{df_class}}.new({{names}}, metadata: {{metadata}}, stop: {{stop}})
    end
  end
end
