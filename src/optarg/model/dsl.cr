module Optarg
  class Model
    macro __define_value_container(type)
      {%
        snakecase = type.id.split("::").map{|i| i.gsub(/([A-Z])/, "_\\1")}.join("__").gsub(/^_/, "").downcase
        attribute_name = "@__optarg_#{snakecase.id}_options"
      %}

      {% unless @type.has_attribute?(attribute_name) %}
        @__optarg_{{snakecase.id}}_options = ::Hash(::String, ::{{type.id}}).new
        getter :__optarg_{{snakecase.id}}_options
      {% end %}
    end

    macro __define_option(type, mixin, names)
      {%
        snakecase = type.id.split("::").map{|i| i.gsub(/([A-Z])/, "_\\1")}.join("__").gsub(/^_/, "").downcase
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Option_" + method_names[0]
      %}

      module Options
        class {{class_name.id}} < ::{{@type.id}}::Option
          class Metadata < ::{{@type.id}}::Option::Metadata
          end

          include {{mixin.id}}

          def metadata
            @metadata as Metadata
          end

          def as_result(result)
            if result.is_a?(::{{@type.id}})
              result as ::{{@type.id}}
            end
          end

          def set_default(result)
            return unless default = @default
            return unless result = as_result(result)
            result.__optarg_{{snakecase.id}}_options[key] = default
          end
        end
      end
    end

    macro __define_string_option(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
      %}

      __define_value_container ::String
      __define_option ::String, ::Optarg::OptionMixins::String, {{names}}

      {% for method_name, index in method_names %}
        def {{method_name.id}}
          @__optarg_string_options[{{names[0]}}]
        end

        def {{method_name.id}}?
          @__optarg_string_options[{{names[0]}}]?
        end
      {% end %}
    end

    macro __add_string_option(names, default = nil, metadata = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Option_" + method_names[0]
      %}

      %option = Options::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, default: {{default}})
      @@self_options[%option.key] = %option
    end

    macro string(names, metadata = nil, default = nil)
      __define_string_option {{names}}
      __add_string_option {{names}}, metadata: {{metadata}}, default: {{default}}
    end

    macro __define_bool_option(names, default = nil, not = %w())
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        not = [not] unless not.class_name == "ArrayLiteral"
      %}

      __define_value_container ::Bool
      __define_option ::Bool, ::Optarg::OptionMixins::Bool, {{names}}

      {% for method_name, index in method_names %}
        def {{method_name.id}}?
          !!@__optarg_bool_options[{{names[0]}}]?
        end
      {% end %}
    end

    macro __add_bool_option(names, metadata = nil, default = nil, not = %w())
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        not = [not] unless not.class_name == "ArrayLiteral"
        class_name = "Option_" + method_names[0]
      %}

      %option = Options::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, default: {{default}}, not: {{not}})
      @@self_options[%option.key] = %option
    end

    macro bool(names, metadata = nil, default = nil, not = %w())
      __define_bool_option {{names}}
      __add_bool_option {{names}}, metadata: {{metadata}}, default: {{default}}, not: {{not}}
    end

    macro __define_handler(names, &block)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Handler_" + method_names[0]
      %}

      def __optarg_on_{{method_names[0].id}}
        __optarg_yield {{block}}
      end

      module Handlers
        class {{class_name.id}} < ::{{@type.id}}::Handler
          class Metadata < ::{{@type.id}}::Handler::Metadata
          end

          def metadata
            @metadata as Metadata
          end

          def parse(args, index, result)
            if is_name?(args[index])
              result.__optarg_on_{{method_names[0].id}} if result.responds_to?(:__optarg_on_{{method_names[0].id}})
              index + 1
            else
              index
            end
          end
        end
      end
    end

    macro __add_handler(names, metadata = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Handler_" + method_names[0]
      %}

      %handler = Handlers::{{class_name.id}}.new({{names}}, metadata: {{metadata}})
      @@self_handlers[%handler.key] = %handler
    end

    macro __handler_metadata_class_of(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Handler_" + method_names[0]
      %}

      Handlers::{{class_name.id}}::Metadata
    end

    macro on(names, metadata = nil, &block)
      __define_handler {{names}} {{block}}
      __add_handler {{names}}, {{metadata}}
    end
  end
end
