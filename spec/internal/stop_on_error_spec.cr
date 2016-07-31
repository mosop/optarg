require "../spec_helper"

module OptargStopOnErrorFeature
  class Model < Optarg::Model
  end

  it name do
    result = Model.parse(%w(-s), stops_on_error: true)
    result.__left_args.should eq %w(-s)
  end
end
