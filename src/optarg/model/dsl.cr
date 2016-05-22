module Optarg
  class Model
    macro __define_value_container_for_type(type)
      {%
        downcase = type.id.split("::").map(&.downcase).join("__")
      %}

      @__optarg_{{downcase.id}}_options = ::Hash(::String, ::{{type.id}}).new
      getter :__optarg_{{downcase.id}}_options
    end

    macro __define_option_for_type(type)
      {%
        downcase = type.id.split("::").map(&.downcase).join("__")
      %}

      module OptionBases
        abstract class {{type.id}} < ::{{@type.id}}::Option
          abstract class Metadata < ::{{@type.id}}::Option::Metadata
          end

          @default : ::{{type.id}}?
          getter :default

          def initialize(names, metadata = nil, @default = nil)
            super names, metadata: metadata
          end

          def set_default(result)
            return unless result.responds_to?(:__optarg_{{downcase.id}}_options)
            return if @default.nil?
            result.__optarg_{{downcase.id}}_options[key] = @default as ::{{type.id}}
          end
        end
      end
    end

    macro define_type(type)
      __define_value_container_for_type {{type}}
      __define_option_for_type {{type}}
    end

    macro define_string_type(options)
      {% unless options.resolve.has_constant?("String") %}
        define_type ::String
        module Options
          class String < ::{{@type.id}}::OptionBases::String
            class Metadata < ::{{@type.id}}::OptionBases::String::Metadata
            end

            def metadata
              @metadata as Metadata
            end

            def parse(args, index, result)
              return index unless result.responds_to?(:__optarg_string_options)
              if is_name?(args[index])
                raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
                result.__optarg_string_options[key] = args[index + 1]
                index + 2
              else
                index
              end
            end
          end
        end
      {% end %}
    end

    macro __define_string_option(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
      %}

      define_string_type ::{{@type.id}}::Options

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
      %}

      %option = Options::String.new({{names}}, metadata: {{metadata}}, default: {{default}})
      @@self_options[%option.key] = %option
    end

    macro string(names, metadata = nil, default = nil)
      __define_string_option {{names}}
      __add_string_option {{names}}, metadata: {{metadata}}, default: {{default}}
    end

    macro define_bool_type(options)
      {% unless options.resolve.has_constant?("Bool") %}
        define_type ::Bool
        module Options
          class Bool < ::{{@type.id}}::OptionBases::Bool
            class Metadata < ::{{@type.id}}::OptionBases::Bool::Metadata
            end

            def metadata
              @metadata as Metadata
            end

            @not = [] of ::String

            def initialize(names, metadata = nil, default = nil, @not = [] of ::String)
              super names, metadata: metadata, default: default
            end

            def parse(args, index, result)
              return index unless result.responds_to?(:__optarg_bool_options)
              if is_name?(args[index])
                result.__optarg_bool_options[key] = true
                index + 1
              elsif is_not?(args[index])
                result.__optarg_bool_options[key] = false
                index + 1
              else
                index
              end
            end

            def is_not?(name)
              @not.includes?(name)
            end
          end
        end
      {% end %}
    end

    macro __define_bool_option(names, default = nil, not = %w())
      define_bool_type ::{{@type.id}}::Options

      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        not = [not] unless not.class_name == "ArrayLiteral"
      %}

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
      %}

      %option = Options::Bool.new({{names}}, metadata: {{metadata}}, default: {{default}}, not: {{not}})
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
        class_name = method_names[0].split("_").map{|i| i.capitalize}.join("")
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
        class_name = method_names[0].split("_").map{|i| i.capitalize}.join("")
      %}

      %handler = Handlers::{{class_name.id}}.new({{names}}, metadata: {{metadata}})
      @@self_handlers[%handler.key] = %handler
    end

    macro __handler_metadata_class_of(names)
      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
        class_name = method_names[0].split("_").map{|i| i.capitalize}.join("")
      %}

      Handlers::{{class_name.id}}::Metadata
    end

    macro on(names, metadata = nil, &block)
      __define_handler {{names}} {{block}}
      __add_handler {{names}}, {{metadata}}
    end
  end
end
