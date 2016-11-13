require "../../spec_helper"

module OptargBoolOptionValueAccessorFeatureDetail
  class Model < Optarg::Model
    bool "-b"
  end

  it name do
    result = Model.parse(%w(-b))
    result.b?.should be_true
    result.options.b?.should be_true

    not_set = Model.parse(%w())
    not_set.b?.should be_false
    not_set.options.b?.should be_false
  end
end
