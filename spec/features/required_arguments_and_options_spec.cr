require "../spec_helper"

module Optarg::RequiredArgumentsAndOptionsFeature
  class Compile < Optarg::Model
    arg "source_file", required: true
  end

  it "Required Arguments" do
    expect_raises(Optarg::RequiredArgumentError) { Compile.parse %w() }
  end

  class Profile < Optarg::Model
    string "--birthday", required: true
  end

  it "Required Options" do
    expect_raises(Optarg::RequiredOptionError) { Profile.parse %w() }
  end
end
