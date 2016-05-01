module Optarg
  class Model
    macro define_value_container_for_type(type)
      {%
        downcase = type.id.split("::").map(&.downcase).join("__")
      %}

      @__optarg_{{downcase.id}}_options = ::Hash(::String, ::{{type.id}}).new
      getter :__optarg_{{downcase.id}}_options
    end

    macro define_option_for_type(type)
      {%
        downcase = type.id.split("::").map(&.downcase).join("__")
      %}

      module OptionBases
        abstract class {{type.id}} < ::{{@type.id}}::Option
          @default : ::{{type.id}}?
          getter :default

          def initialize(names, description = nil, @default = nil)
            super names, description: description, default_string: @default.nil? ? nil : @default.to_s
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
      define_value_container_for_type {{type}}
      define_option_for_type {{type}}
    end

    macro define_string_type(options)
      {% unless options.resolve.has_constant?("String") %}
        define_type ::String
        module Options
          class String < ::{{@type.id}}::OptionBases::String
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

    macro string(names, desc = nil, default = nil)
      define_string_type ::{{@type.id}}::Options

      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        method_names = names.map{|i| i.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")}
      %}

      {% for method_name, index in method_names %}
        def {{method_name.id}}
          @__optarg_string_options[{{names[0]}}]
        end

        def {{method_name.id}}?
          @__optarg_string_options[{{names[0]}}]?
        end
      {% end %}

      self.definition_set << Options::String.new({{names}}, description: {{desc}}, default: {{default}})
    end

    macro define_bool_type(options)
      {% unless options.resolve.has_constant?("Bool") %}
        define_type ::Bool
        module Options
          class Bool < ::{{@type.id}}::OptionBases::Bool
            @not = [] of ::String

            def initialize(names, description = nil, default = nil, @not = [] of ::String)
              super names, description: description, default: default
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

    macro bool(names, desc = nil, default = nil, not = %w())
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

      self.definition_set << Options::Bool.new({{names}}, description: {{desc}}, default: {{default}}, not: {{not}})
    end

    macro on(names, desc = nil, &block)
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

      self.definition_set << Handlers::{{class_name.id}}.new({{names}}, description: {{desc}})
    end
  end
end
