require "../../spec_helper"

module OptargUnparsedArgumentValueArrayFeatureDetail
  class Model < Optarg::Model
    arg "stopper", stop: true
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    expected = %w(bar baz)
    result.unparsed_args.should eq expected
  end
end
