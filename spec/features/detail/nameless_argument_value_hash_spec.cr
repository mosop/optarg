require "../../spec_helper"

module OptargNamelessArgumentValueHashFeatureDetail
  class Model < Optarg::Model
    arg "named"
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    expected = %w(bar baz)
    result.nameless_args.should eq expected
  end
end
