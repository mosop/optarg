module Optarg
  class Model
    macro __define_hashed_value_container(type)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "__options__#{snake.id}"
        variable_name = "@#{attribute_name.id}"
      %}

      {% unless @type.has_attribute?(variable_name) %}
        {{variable_name.id}} = ::Hash(::String, ::{{type.id}}).new
        getter :{{attribute_name.id}}
      {% end %}
    end

    macro __define_hashed_array_value_container(type)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "__array_options__#{snake.id}"
        variable_name = "@#{attribute_name.id}"
      %}

      {% unless @type.has_attribute?(variable_name) %}
        {{variable_name.id}} = ::Hash(::String, ::Array(::{{type.id}})).new
        getter :{{attribute_name.id}}
      {% end %}
    end

    macro __define_hashed_value_option(type, mixin, names)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "__options__#{snake.id}"
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

          def as_data(data)
            data.as?(::{{@type.id}})
          end

          def set_default(data)
            return unless default = get_default
            return unless data = as_data(data)
            data.{{attribute_name.id}}[key] = default
          end
        end
      end
    end

    macro __define_hashed_array_value_option(type, mixin, names)
      {%
        snake = type.id.split("::").map{|i| i.underscore}.join("__").gsub(/^_+/, "")
        attribute_name = "__array_options__#{snake.id}"
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

          def as_data(data)
            data.as?(::{{@type.id}})
          end

          def set_default(data)
            return unless default = get_default
            return unless data = as_data(data)
            data.{{attribute_name.id}}[key] = default
          end
        end
      end
    end

    macro __define_string_option(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
      %}

      __define_hashed_value_container ::String
      __define_hashed_value_option ::String, ::Optarg::OptionMixins::String, {{names}}

      {% for method_name, index in method_names %}
        def {{method_name.id}}
          @__options__string[{{names[0]}}]
        end

        def {{method_name.id}}?
          @__options__string[{{names[0]}}]?
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
      @@__self_options[%option.key] = %option
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

      __define_hashed_value_container ::Bool
      __define_hashed_value_option ::Bool, ::Optarg::OptionMixins::Bool, {{names}}

      {% for method_name, index in method_names %}
        def {{method_name.id}}?
          !!@__options__bool[{{names[0]}}]?
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
      @@__self_options[%option.key] = %option
    end

    macro bool(names, metadata = nil, default = nil, not = %w())
      __define_bool_option {{names}}
      __add_bool_option {{names}}, metadata: {{metadata}}, default: {{default}}, not: {{not}}
    end

    macro __define_string_array_option(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
      %}

      __define_hashed_array_value_container ::String
      __define_hashed_array_value_option ::String, ::Optarg::OptionMixins::Array(String), {{names}}

      {% for method_name, index in method_names %}
        def {{method_name.id}}
          @__array_options__string[{{names[0]}}]
        end
      {% end %}
    end

    macro __add_string_array_option(names, default = nil, metadata = nil)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = "Option_" + method_names[0]
      %}

      %option = Options::{{class_name.id}}.new({{names}}, metadata: {{metadata}}, default: {{default}})
      @@__self_options[%option.key] = %option
    end

    macro array(names, metadata = nil, default = nil)
      __define_string_array_option {{names}}
      __add_string_array_option {{names}}, metadata: {{metadata}}, default: {{default}}
    end

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

    macro __add_argument(name, metadata = nil)
      {%
        upcase = name.upcase
        method_name = name.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
        class_name = "Argument_" + method_name
      %}

      %arg = Arguments::{{class_name.id}}.new({{upcase}}, metadata: {{metadata}})
      @@__self_arguments[%arg.key] = %arg
    end

    macro arg(name, metadata = nil)
      __define_argument {{name}}
      __add_argument {{name}}, {{metadata}}
    end

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

          def parse(arg, data)
            if is_name?(arg)
              data.__handle_{{method_names[0].id}} if data.responds_to?(:__handle_{{method_names[0].id}})
              true
            else
              false
            end
          end

          def parse(args, index, data)
            if parse(args[index], data)
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
      @@__self_handlers[%handler.key] = %handler
    end

    macro on(names, metadata = nil, &block)
      __define_handler {{names}} {{block}}
      __add_handler {{names}}, {{metadata}}
    end

    macro __option_metadata_class_of(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        class_name = "Option_" + names[0].split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
      %}

      Options::{{class_name.id}}::Metadata
    end

    macro __handler_metadata_class_of(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        class_name = "Handler_" + names[0].split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
      %}

      Handlers::{{class_name.id}}::Metadata
    end
  end
end
