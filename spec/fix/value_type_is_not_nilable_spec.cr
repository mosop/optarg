require "../spec_helper"

module OptargFixValueTypeIsNotNilableFeature
  class Model < Optarg::Model
  end

  it name do
    model = Model.new(%w())
    model.__parser.parsed_args.class.should eq Array(String)
    model.__parser.args[String].class.should eq Optarg::Definitions::StringArgument::Typed::ValueHash
    model.__parser.args[Array(String)].class.should eq Optarg::Definitions::StringArrayArgument::Typed::ValueHash
    model.__parser.options[String].class.should eq Optarg::Definitions::StringOption::Typed::ValueHash
    model.__parser.options[Bool].class.should eq Optarg::Definitions::BoolOption::Typed::ValueHash
    model.__parser.options[Array(String)].class.should eq Optarg::Definitions::StringArrayOption::Typed::ValueHash
  end
end
