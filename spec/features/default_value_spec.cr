require "../spec_helper"

module Optarg::DefaultValueFeature
  class Model < ::Optarg::Model
    string "--foo", default: "bar"
  end
end

describe "Features" do
  it "Default Value" do
    result = Optarg::DefaultValueFeature::Model.parse(%w())
    result.foo.should eq "bar"
  end
end
