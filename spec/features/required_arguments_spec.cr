require "../spec_helper"

module Optarg::RequiredArgumentsFeature
  class Profile < Optarg::Model
    string "--birth", required: true
  end

  it "Required Arguments" do
    expect_raises(Optarg::RequiredError) { Profile.parse %w() }
  end
end
