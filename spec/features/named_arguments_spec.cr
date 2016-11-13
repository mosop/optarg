require "../spec_helper"

module OptargNamedArgumentsFeature
  class Model < Optarg::Model
    arg "src_dir"
    arg "build_dir"
  end

  it name do
    result = Model.parse(%w(/path/to/src /path/to/build and more))
    result.src_dir.should eq "/path/to/src"
    result.build_dir.should eq "/path/to/build"
    result.args.should eq ["/path/to/src", "/path/to/build", "and", "more"]
    result.args.src_dir.should eq "/path/to/src"
    result.args.build_dir.should eq "/path/to/build"
    result.named_args.should eq({"src_dir" => "/path/to/src", "build_dir" => "/path/to/build"})
    result.nameless_args.should eq ["and", "more"]
  end
end
