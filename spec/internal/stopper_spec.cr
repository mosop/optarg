require "../spec_helper"

module OptargStopperFeature
  class Model < Optarg::Model
    arg "arg1", stop: true
    arg "arg2"
  end

  it name do
    result = Model.parse(%w(arg1 arg2))
    result.arg1.should eq "arg1"
    result.arg2?.should be_nil
    result.left_args.should eq %w(arg2)
  end
end
