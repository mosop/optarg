require "../spec_helper"

module OptargInternalRaiseUnsupportedConcatenationFeature
  class Model < Optarg::Model
    string "-s"
    bool "-b"
  end

  it name do
    model = Model.new(%w(-sa))
    expect_raises(Optarg::UnsupportedConcatenation, Optarg::UnsupportedConcatenation.new(model.__parser, Model.definitions.options["-s"]).message) { model.__parse}
  end
end
