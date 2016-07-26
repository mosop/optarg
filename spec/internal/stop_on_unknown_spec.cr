require "../spec_helper"

module OptargStopOnUnknownFeature
  class Model < Optarg::Model
  end

  describe name do
    result = Model.parse(%w(-s), stops_on_unknown: true)
    result.__left_args.should eq %w(-s)
  end
end
