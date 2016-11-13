require "../spec_helper"

module OptargNilableAccessorFeature
  class Model < Optarg::Model
    string "--foo"
  end

  it name do
    result = Model.parse(%w())
    result.foo?.should be_nil
    expect_raises(KeyError) { result.foo }
  end
end
