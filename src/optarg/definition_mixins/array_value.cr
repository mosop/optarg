module Optarg::DefinitionMixins
  module ArrayValue
    macro included
      include ::Optarg::DefinitionMixins::Value

      module ArrayValueModule
        def initialize_array_value(default, min : Int32?, any_item_of : ::Array(Typed::ElementValue) | ::Array(Typed::ElementType) | Nil)
          initialize_value default: default
          validations << new_minimum_length_of_array_validation(min) if min
          validations << new_element_inclusion_validation(any_item_of) if any_item_of
        end

        def fallback_value(parser)
          set_value parser, Typed::Type.new
        end

        def get_typed_element_values(parser)
          a = [] of Typed::ElementValue
          if v = get_value?(parser)
            v.each do |i|
              a << Typed::ElementValue.new(i)
            end
          end
          a
        end

        def value_required?
          validations.any? do |v|
            if v = v.as?(Validations::MinimumLengthOfArray)
              v.min > 0
            end
          end
        end

        module Validations
          class MinimumLengthOfArray < Validation
            getter min : Int32

            def initialize(@min)
            end

            def valid?(parser, df)
              df.get_value(parser).size >= min
            end
          end

          class ElementInclusion < Validation
            getter values : ::Array(Typed::ElementValue)

            def initialize(@values : ::Array(Typed::ElementValue))
            end

            def initialize(values : ::Array(Typed::ElementType))
              initialize values.map{|i| Typed::ElementValue.new(i)}
            end

            def valid?(parser, df)
              typed = df.get_typed_element_values(parser)
              typed.all?{|i| values.any?{|j| i == j } }
            end
          end
        end

        def minimum_length_of_array
          validations.each do |i|
            if v = i.as?(Validations::MinimumLengthOfArray)
              return v.min
            end
          end
          0
        end

        def initialize_after_parse(parser)
          set_default_value_on_after_parse(parser)
          super
        end

        def set_default_value_on_after_parse(parser)
          a = get_value(parser)
          set_default_value parser if a.empty?
        end

        def completion_words(gen)
          super || begin
            a = \%w()
            validations.each do |v|
              if v = v.as?(Validations::ElementInclusion)
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
      end

      include ArrayValueModule
    end
  end
end
