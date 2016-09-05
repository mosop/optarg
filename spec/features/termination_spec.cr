require "../spec_helper"

module OptargTerminationFeature
  class Model < Optarg::Model
    terminator "--"
  end

  it name do
    result = Model.parse(%w(foo -- bar))
    result.args.should eq %w(foo)
    result.unparsed_args.should eq %w(bar)
  end
end
