require "../spec_helper"

module Optarg::AccessibleArgumentsFeature
  class Model < ::Optarg::Model
    arg "src_dir"
    arg "build_dir"
  end

  it "Accessible Arguments" do
    result = Model.parse(%w(/path/to/src /path/to/build more args))
    result.src_dir.should eq "/path/to/src"
    result.build_dir.should eq "/path/to/build"
    result.args.should eq %w(more args)
  end
end
