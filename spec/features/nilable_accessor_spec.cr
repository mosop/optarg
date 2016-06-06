require "../spec_helper"

module Optarg::NilableAccessorFeature
  class Model < ::Optarg::Model
    string "--foo"
  end
end

describe "Nilable Accessor" do
  it "" do
    result = Optarg::NilableAccessorFeature::Model.parse(%w())
    result.foo?.should be_nil
    expect_raises(KeyError) { result.foo }
  end
end
