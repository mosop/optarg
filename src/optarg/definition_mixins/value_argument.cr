module Optarg::DefinitionMixins
  module ValueArgument
    macro included
      include ::Optarg::DefinitionMixins::Argument

      module ValueArgumentModule
        def get_value?(parser)
          parser.args[Typed::Type][value_key]?
        end

        def set_value(parser, value)
          parser.args[Typed::Type][value_key] = value
        end
      end

      include ValueArgumentModule
    end
  end
end
