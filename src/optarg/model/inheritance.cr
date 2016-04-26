module Optarg
  class Model
    macro inherited
      {%
        if @type.superclass == ::Optarg::Model
          super_parser = "Optarg::Parser"
          super_option = "Optarg::Option"
          super_option_set = "Optarg::OptionSet"
          option_set_base = "nil"
        else
          super_parser = "#{@type.superclass.id}::Parser"
          super_option = "#{@type.superclass.id}::Option"
          super_option_set = "#{@type.superclass.id}::OptionSet"
          option_set_base = "::#{@type.superclass.id}.option_set"
        end %}

      class Parser(T) < ::{{super_parser.id}}(T)
        def self.model
          ::{{@type.id}}
        end
      end

      module Options
      end

      abstract class Option < ::{{super_option.id}}
      end

      class OptionSet < ::{{super_option_set.id}}
        def base
          {{option_set_base.id}}
        end
      end

      @@option_set = OptionSet.new

      def self.option_set
        @@option_set
      end

      def self.parse(argv)
        Parser(::{{@type.id}}).parse(argv)
      end
    end
  end
end
