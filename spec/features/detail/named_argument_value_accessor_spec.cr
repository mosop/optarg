require "../../spec_helper"

module OptargNamedArgumentValueAccessorFeatureDetail
  class Model < Optarg::Model
    arg "arg1"
    arg "arg2"
  end

  it name do
    result = Model.parse(%w(foo bar))
    result.arg1.should eq "foo"
    result.arg2.should eq "bar"
    result.args.arg1.should eq "foo"
    result.args.arg2.should eq "bar"
  end
end
