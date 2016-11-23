require "../spec_helper"

module OptargOptionValueContainerClassFeature
  class Model < Optarg::Model
  end

  it "#[]" do
    model = Model.new(%w())
    model.options[String].class.should eq Optarg::Definitions::StringOption::Typed::ValueHash
    model.options[Bool].class.should eq Optarg::Definitions::BoolOption::Typed::ValueHash
    model.options[Array(String)].class.should eq Optarg::Definitions::StringArrayOption::Typed::ValueHash
  end
end
