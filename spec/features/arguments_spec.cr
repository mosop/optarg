require "../spec_helper"

module Optarg::ArgumentsFeature
  class Model < ::Optarg::Model
    string "-s"
    bool "-b"
  end
end

describe "Features" do
  it "Arguments" do
    result = Optarg::ArgumentsFeature::Model.parse(%w(-s foo -b bar -- baz))
    result.args.should eq %w(bar)
    result.unparsed_args.should eq %w(baz)
  end
end
