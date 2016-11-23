require "../spec_helper"

module OptargArgumentValueContainerClassFeature
  class Model < Optarg::Model
  end

  it "#[]" do
    model = Model.new(%w())
    model.__args.__values << "arg"
    model.__args.__values[0].should eq "arg"
  end

  it "#[]?" do
    model = Model.new(%w())
    model.__args.__values[0]?.should be_nil
  end
end
