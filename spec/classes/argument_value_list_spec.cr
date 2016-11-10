require "../spec_helper"

module Optarg::ArgumentValueListFeature
  class Model < Optarg::Model
  end

  it "#<< and #[]" do
    list = Model::ArgumentValueList.new
    list << "arg"
    list[0].should eq "arg"
  end

  it "#[]?" do
    list = Model::ArgumentValueList.new
    list[0]?.should be_nil
  end
end
