require "../spec_helper"

module Optarg::RequiredArgumentsFeature
  class Birthday < Optarg::Model
    string "--when", required: true
  end

  it "Required Arguments" do
    expect_raises(Optarg::RequiredError) { Birthday.parse %w() }
  end
end
