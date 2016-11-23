require "../spec_helper"

module OptargInternalRaiseUnknownOptionIfConcatenatedOptionsNotMatchedFeature
  class Model < Optarg::Model
  end

  it name do
    model = Model.new(%w(-ab))
    expect_raises(Optarg::UnknownOption, Optarg::UnknownOption.new(model.__parser, "-a").message) { model.parse }
  end
end
