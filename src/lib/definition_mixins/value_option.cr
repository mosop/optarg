module Optarg::DefinitionMixins
  module ValueOption
    macro included
      include ::Optarg::DefinitionMixins::Option

      module ValueOptionModule
        def get_value?(parser)
          parser.args[Typed::Type][value_key]?
        end

        def set_value(parser, value)
          parser.args[Typed::Type][value_key] = value
        end
      end

      include ValueOptionModule
    end
  end
end
