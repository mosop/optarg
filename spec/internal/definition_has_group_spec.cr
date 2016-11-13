require "../spec_helper"

module OptargInternalDefinitionHasGroupFeature
  class Model < Optarg::Model
    arg "arg", group: :arg
    array "-a", group: :array
    string "-s", group: :string
    bool "-b", group: :bool
    on "-h", group: :handler
  end

  it name do
    Model.__arguments["arg"].group.should eq :arg
    Model.__options["-a"].group.should eq :array
    Model.__options["-s"].group.should eq :string
    Model.__options["-b"].group.should eq :bool
    Model.__handlers["-h"].group.should eq :handler
  end
end
