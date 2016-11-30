require "../spec_helper"

module OptargInternalArugmentDisplayNameFeature
  class Metadata < Optarg::Metadata
    def display_name
      if definition.is_a?(Optarg::DefinitionMixins::Argument)
        super.upcase
      else
        super
      end
    end
  end

  class Model < Optarg::Model
    arg "arg"
  end

  class Upcase < Optarg::Model
    arg "arg", metadata: Metadata.new
    string "--option"
  end

  it name do
    Model.definitions.arguments["arg"].metadata.display_name.should eq "arg"
    Upcase.definitions.arguments["arg"].metadata.display_name.should eq "ARG"
    Upcase.definitions.options["--option"].metadata.display_name.should eq "--option"
  end
end
