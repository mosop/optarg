require "../spec_helper"

module OptargArugmentDisplayNamesFeature
  class Model < Optarg::Model
    arg "arg1", group: :arg
    arg "arg2", group: :arg

    class Arguments::Argument_arg2
      def display_name
        super.upcase
      end
    end
  end

  it name do
    Model.__arguments["arg1"].display_name.should eq "arg1"
    Model.__arguments["arg2"].display_name.should eq "ARG2"
  end
end
