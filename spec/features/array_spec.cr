require "../spec_helper"

module OptargArrayFeature
  class Model < Optarg::Model
    array "-e"
  end

  it name do
    result = Model.parse(%w(-e foo -e bar -e baz))
    result.e.should eq %w(foo bar baz)
  end
end
