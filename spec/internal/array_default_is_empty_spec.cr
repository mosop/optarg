require "../spec_helper"

module OptargInternalArugmentDisplayNameFeature
  class Model < Optarg::Model
    array "-a"
  end

  it name do
    result = Model.parse(%w())
    result.a.should eq %w()
  end
end
