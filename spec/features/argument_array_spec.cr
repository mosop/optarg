require "../spec_helper"

module OptargArgumentArrayFeature
  class Model < Optarg::Model
    arg "arg"
    arg_array "item"
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    result.arg.should eq "foo"
    result.item.should eq ["bar", "baz"]
  end
end
