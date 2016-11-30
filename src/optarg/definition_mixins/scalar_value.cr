module Optarg::DefinitionMixins
  module ScalarValue
    macro included
      include ::Optarg::DefinitionMixins::Value

      module ScalarValueModule
        def initialize_scalar_value(default, required : Bool?, any_of : ::Array(Typed::Value) | ::Array(Typed::Type) | Nil)
          initialize_value default
          require_value! if required
          any_value_of!(any_of) if any_of
        end

        def fallback_value(parser)
          set_default_value parser
        end

        def require_value!
          value_validations << Validations::Required.new unless value_required?
        end

        def unrequire_value!
          value_validations.reject! do |v|
            v.is_a?(Validations::Required)
          end
        end

        def any_value_of!(values)
          value_validations << Validations::Inclusion.new(values)
          require_value!
        end

        def value_required?
          value_validations.any? do |i|
            i.is_a?(Validations::Required)
          end
        end

        module Validations
          class Required < Typed::Validation
            def valid?(parser, df)
              df.get_typed_value(parser).exists?
            end
          end

          class Inclusion < Typed::Validation
            getter values : ::Array(Typed::Value)

            def initialize(@values : ::Array(Typed::Value))
            end

            def initialize(values : ::Array(Typed::Type))
              initialize values.map{|i| Typed::Value.new(i)}
            end

            def valid?(parser, df)
              typed = df.get_typed_value(parser)
              values.any?{|i| i == typed}
            end
          end
        end

        def completion_words(gen)
          a = \%w()
          value_validations.each do |v|
            if v = v.as?(Validations::Inclusion)
              v.values.each do |val|
                if s = val.string
                  a << s
                end
              end
            end
          end
          a.uniq!
        end
      end

      include ScalarValueModule
    end
  end
end
