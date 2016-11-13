require "../../spec_helper"

module OptargStringOptionValueAccessorFeatureDetail
  class Model < Optarg::Model
    string "-s"
  end

  it name do
    result = Model.parse(%w(-s value))
    result.s.should eq "value"
    result.options.s.should eq "value"

    not_set = Model.parse(%w())
    expect_raises(KeyError) { not_set.s }
    not_set.s?.should be nil
    expect_raises(KeyError) { not_set.options.s }
    not_set.options.s?.should be nil
  end
end
