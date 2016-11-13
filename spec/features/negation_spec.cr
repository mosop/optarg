require "../spec_helper"

module OptargNegationFeature
  class Model < Optarg::Model
    bool "-b", default: true, not: "-B"
  end

  it name do
    result = Model.parse(%w(-B))
    result.b?.should be_false
  end
end
