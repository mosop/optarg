require "../spec_helper"

module OptargFixValueTypeIsNotNilableFeature
  class Model < Optarg::Model
  end

  it name do
    model = Model.new(%w())
    model.args.__values.class.should eq Array(String)
    model.args.__named.class.should eq Optarg::Definitions::StringArgument::Typed::ValueHash
    model.options[String].class.should eq Optarg::Definitions::StringOption::Typed::ValueHash
    model.options[Bool].class.should eq Optarg::Definitions::BoolOption::Typed::ValueHash
    model.options[Array(String)].class.should eq Optarg::Definitions::StringArrayOption::Typed::ValueHash
  end
end
