require "../spec_helper"

module Optarg::NegationFeature
  class Model < ::Optarg::Model
    bool "-b", default: true, not: "-B"
  end
end

describe "Features" do
  it "Negation" do
    result = Optarg::NegationFeature::Model.parse(%w(-B))
    result.b?.should be_false
  end
end
