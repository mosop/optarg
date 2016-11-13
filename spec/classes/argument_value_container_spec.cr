require "../spec_helper"

module OptargArgumentValueContainerClassFeature
  class Model < Optarg::Model
  end

  it "#[]" do
    list = Model::ArgumentValueContainer.new
    list.__values << "arg"
    list[0].should eq "arg"
  end

  it "#[]?" do
    list = Model::ArgumentValueContainer.new
    list[0]?.should be_nil
  end
end
