require "../../spec_helper"

module OptargStringArrayOptionValueAccessorFeatureDetail
  class Model < Optarg::Model
    array "-a"
  end

  it name do
    result = Model.parse(%w(-a foo -a bar -a baz))
    result.a.should eq %w(foo bar baz)
    result.options.a.should eq %w(foo bar baz)
  end
end
