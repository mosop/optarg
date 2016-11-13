require "../spec_helper"

module OptargInternalArrayDefaultFeature
  class Model < Optarg::Model
    array "-a", default: %w(default)
  end

  it name do
    Model.parse(%w()).a.should eq %w(default)
    Model.parse(%w(-a specified)).a.should eq %w(specified)
  end
end
