require "../spec_helper"

module OptargInternalArugmentHasDefaultSetterFeature
  class Model < Optarg::Model
    arg "arg", default: "default"
  end

  it name do
    Model.__arguments["arg"].default = "changed"
    Model.__arguments["arg"].default.should eq "changed"
  end
end
