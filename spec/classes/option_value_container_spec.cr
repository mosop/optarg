require "../spec_helper"

module OptargOptionValueContainerClassFeature
  class Model < Optarg::Model
  end

  it "#[]" do
    model = Model.new(%w())
    model[String].class.should eq Optarg::Definitions::StringOption::Typed::ValueHash
    model[Bool].class.should eq Optarg::Definitions::BoolOption::Typed::ValueHash
    model[Array(String)].class.should eq Optarg::Definitions::StringArrayOption::Typed::ValueHash
  end
end
