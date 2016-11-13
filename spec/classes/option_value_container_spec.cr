require "../spec_helper"

module OptargOptionValueContainerClassFeature
  class Model < Optarg::Model
  end

  it "#[]" do
    list = Model::OptionValueContainer.new
    list[String].class.should eq Hash(String, String?)
    list[Bool].class.should eq Hash(String, Bool?)
    list[Array(String)].class.should eq Hash(String, Array(String))
  end
end
