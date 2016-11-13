require "../spec_helper"

module OptargDefaultValueFeature
  class Model < Optarg::Model
    string "-s", default: "string"
    bool "-b", default: false
    array "-a", default: %w(1 2 3)
    arg "arg", default: "arg"
  end

  it name do
    result = Model.parse(%w())
    result.s.should eq "string"
    result.b?.should be_false
    result.a.should eq %w(1 2 3)
    result.args.arg.should eq "arg"
  end
end
