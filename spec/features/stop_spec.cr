require "../spec_helper"

module OptargStopFeature
  class Model < Optarg::Model
    bool "-b", stop: true
  end

  it name do
    result = Model.parse(%w(foo -b bar))
    result.b?.should be_true
    result.args.should eq %w(foo)
    result.unparsed_args.should eq %w(bar)
  end
end
