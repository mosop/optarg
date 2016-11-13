require "../spec_helper"

module OptargInternalRaiseUnsupportedConcatenationFeature
  class Model < Optarg::Model
    string "-s"
    array "-a"
  end

  it name do
    expect_raises(Optarg::UnsupportedConcatenation, Optarg::UnsupportedConcatenation.new("-s").message) { Model.parse %w(-sa)}
  end
end
