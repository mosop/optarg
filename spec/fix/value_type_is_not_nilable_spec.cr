require "../spec_helper"

module OptargFixValueTypeIsNotNilableFeature
  class Model < Optarg::Model
  end

  it name do
    model = Model.new(%w())
    model.__parser.parsed_args.class.should eq Array(String)
    model.__parser.args[String].class.should eq Optarg::ValueTypes::String::ValueHash
    model.__parser.args[Bool].class.should eq Optarg::ValueTypes::Bool::ValueHash
    model.__parser.args[Array(String)].class.should eq Optarg::ValueTypes::StringArray::ValueHash
  end
end
