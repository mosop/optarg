require "../spec_helper"

module Optarg::RequiredArgumentsAndOptionsFeature
  class Compile < Optarg::Model
    arg "source_file", required: true
  end

  it "Required Arguments" do
    expect_raises(Optarg::RequiredError) { Compile.parse %w() }
  end

  class Profile < Optarg::Model
    string "--birth", required: true
  end

  it "Required Options" do
    expect_raises(Optarg::RequiredError) { Profile.parse %w() }
  end
end
