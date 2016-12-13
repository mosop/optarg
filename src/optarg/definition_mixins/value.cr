module Optarg::DefinitionMixins
  module Value
    macro included
      module ValueModule
        getter! default_value : Typed::Value

        def initialize_value(default : Typed::Type | Typed::Value | Nil = nil)
          @default_value = Typed::Value.new(default)
        end

        def value_key
          key
        end

        def get_typed_value(parser)
          Typed::Value.new(get_value?(parser))
        end

        def get_value(parser)
          get_value?(parser).as(Typed::Type)
        end

        def set_default_value(parser)
          set_value parser, default_value.dup_value! if default_value.exists?
        end

        getter validations = [] of Validation

        def validate(parser)
          validations.each{|i| i.validate(parser, self)}
        end
      end

      include ValueModule
    end
  end
end
