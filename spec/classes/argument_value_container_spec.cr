require "../spec_helper"

module OptargArgumentValueContainerClassFeature
  class Model < Optarg::Model
  end

  it "#[]" do
    model = Model.new(%w())
    model.parser.parsed_args << "arg"
    model[0].should eq "arg"
  end

  it "#[]?" do
    model = Model.new(%w())
    model[0]?.should be_nil
  end
end
