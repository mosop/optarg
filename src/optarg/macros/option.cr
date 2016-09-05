module Optarg
  class Model
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
            super.as(Metadata)
          end

          def as_data?(data)
            data.as?(::{{@type.id}})
          end

          def with_data?(data)
            yield data if data = as_data?(data)
          end

          def preset_default_to(data)
            with_default? do |default|
              with_data?(data) do |data|
                data.{{attribute_name.id}}[key] = default
              end
            end
          end

          def postset_default_to(data)
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
            @metadata.as(Metadata)
          end

          def as_data?(data)
            data.as?(::{{@type.id}})
          end

          def with_data?(data)
            yield data if data = as_data?(data)
          end

          def preset_default_to(data)
            with_data?(data) do |data|
              data.{{attribute_name.id}}[key] = ::Array(::{{type.id}}).new
            end
          end

          def postset_default_to(data)
            with_default? do |default|
              with_data?(data) do |data|
                data.{{attribute_name.id}}[key] += default if data.{{attribute_name.id}}[key].empty?
              end
            end
          end
        end
      end
    end
  end
end
