require "../spec_helper"

module Optarg::BooleanValueFeature
  class Model < ::Optarg::Model
    bool "-b"
  end
end

describe "Boolean Value" do
  it "" do
    result = Optarg::BooleanValueFeature::Model.parse(%w(-b))
    result.b?.should be_true
  end
end
