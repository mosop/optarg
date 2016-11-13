require "../../spec_helper"

module OptargParsedArgumentValueArrayFeatureDetail
  class Model < Optarg::Model
    arg "named"
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    expected = %w(foo bar baz)
    result.parsed_args.should eq expected
  end
end
