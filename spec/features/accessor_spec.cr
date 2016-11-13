require "../spec_helper"

module OptargAccessorFeature
  class Model < Optarg::Model
    string "--foo"
  end

  it name do
    result = Model.parse(%w(--foo bar))
    result.foo.should eq "bar"
  end
end
