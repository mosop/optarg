require "../spec_helper"

module Optarg::ConcatenationFeature
  class Model < ::Optarg::Model
    bool "-a"
    bool "-b"
  end
end

describe "Concatenation" do
  it "" do
    result = Optarg::ConcatenationFeature::Model.parse(%w(-ab))
    result.a?.should be_true
    result.b?.should be_true
  end
end
