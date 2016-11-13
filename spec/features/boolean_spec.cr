require "../spec_helper"

module OptargBooleanFeature
  class Model < Optarg::Model
    bool "-b"
  end

  it name do
    result = Model.parse(%w(-b))
    result.b?.should be_true
  end
end
