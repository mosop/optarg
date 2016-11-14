require "../spec_helper"

module OptargFixValueTypeIsNotNilableFeature
  class Model < Optarg::Model
  end

  it name do
    model = Model.new(%w())
    model.args.__values.class.should eq Array(String)
    model.options.__strings.class.should eq Hash(String, String)
    model.options.__bools.class.should eq Hash(String, Bool)
    model.options.__string_arrays.class.should eq Hash(String, Array(String))
  end
end
