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
          alias Value = ::{{type.id}}
          alias DefaultProc = ::Optarg::Model -> Value

          @default : Value | DefaultProc | ::Nil

          def default
            @default
          end

          @names = [] of ::String
          @description = ""

          def initialize(names, desc = "", @default = nil)
            super names, desc: desc
          end

          def set_default(result)
            return unless result.responds_to?(:__optarg_{{downcase.id}}_options)
            return if @default.nil?
            result.__optarg_{{downcase.id}}_options[key] = if @default.is_a?(DefaultProc)
              (default = @default as DefaultProc).call(result)
            else
              default = @default as Value
            end
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
              return index unless is_name?(args[index])
              raise ::Optarg::MissingValue.new(args[index]) unless index + 1 < args.size
              result.__optarg_string_options[key] = args[index+1]
              index + 2
            end
          end
        end
      {% end %}
    end

    macro string(names, desc = "", default = nil)
      define_string_type ::{{@type.id}}::Options

      {%
        names = [names] unless names.is_a?(::ArrayLiteral)
        key = names[0]
        method_name = key.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
      %}

      def {{method_name.id}}
        @__optarg_string_options[{{key}}]
      end

      def {{method_name.id}}?
        @__optarg_string_options[{{key}}]?
      end

      %option = Options::String.new({{names}}, desc: {{desc}}, default: {{default}})
      self.option_set.items << %option
    end

    macro define_bool_type(options)
      {% unless options.resolve.has_constant?("Bool") %}
        define_type ::Bool
        module Options
          class Bool < ::{{@type.id}}::OptionBases::Bool
            @not = [] of ::String

            def initialize(names, desc = "", default = nil, @not = [] of ::String)
              super names, desc: desc, default: default
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

    macro bool(names, desc = "", default = nil, not = %w())
      define_bool_type ::{{@type.id}}::Options

      {%
        names = [names] unless names.class_name == "ArrayLiteral"
        key = names[0]
        not = [not] unless not.class_name == "ArrayLiteral"
        method_name = key.split("=")[0].gsub(/^-*/, "").gsub(/-/, "_")
      %}

      def {{method_name.id}}?
        !!@__optarg_bool_options[{{key}}]?
      end

      %option = Options::Bool.new({{names}}, desc: {{desc}}, default: {{default}}, not: {{not}})
      self.option_set.items << %option
    end
  end
end
