require "../spec_helper"

module OptargInternalOptionHasRequiredMethodFeature
  class Model < Optarg::Model
    arg "arg"
    arg "required_arg", required: true
    string "-s"
    string "--required-s", required: true
    bool "-b"
    array "-a"
    array "--required-a", min: 1
  end

  it name do
    Model.__arguments["arg"].required?.should be_false
    Model.__arguments["required_arg"].required?.should be_true
    Model.__options["-s"].required?.should be_false
    Model.__options["--required-s"].required?.should be_true
    Model.__options["-b"].required?.should be_false
    Model.__options["-a"].required?.should be_false
    Model.__options["--required-a"].required?.should be_true
  end
end
