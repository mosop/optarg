require "../../spec_helper"

module OptargNamedArgumentValueHashFeatureDetail
  class Model < Optarg::Model
    arg "named"
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    expected = {"named" => "foo"}
    result.named_args.should eq expected
  end
end
