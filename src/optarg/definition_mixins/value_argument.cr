module Optarg::DefinitionMixins
  module ValueArgument
    macro included
      include ::Optarg::DefinitionMixins::Argument

      module ValueArgumentModule
        def get_value?(parser)
          parser.args.__named[value_key]?
        end

        def set_value(parser, value)
          parser.args.__named[value_key] = value
        end
      end

      include ValueArgumentModule
    end
  end
end
