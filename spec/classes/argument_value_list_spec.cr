require "../spec_helper"

module Optarg::ArgumentValueListFeature
  class Model < Optarg::Model
  end

  it "#[]" do
    list = Model::ArgumentValueList.new
    list.push "arg"
    list[0].should eq "arg"
  end

  it "#<<" do
    list = Model::ArgumentValueList.new
    list << "arg"
    list[0].should eq "arg"
  end
end
