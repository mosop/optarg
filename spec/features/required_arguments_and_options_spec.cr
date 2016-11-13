require "../spec_helper"

module OptargRequiredArgumentsAndOptionsFeature
  class Compile < Optarg::Model
    arg "source_file", required: true
  end

  class Profile < Optarg::Model
    string "--birthday", required: true
  end

  describe name do
    it "Arguments" do
      expect_raises(Optarg::RequiredArgumentError) { Compile.parse %w() }
    end

    it "Options" do
      expect_raises(Optarg::RequiredOptionError) { Profile.parse %w() }
    end
  end
end
