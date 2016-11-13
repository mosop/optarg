require "../spec_helper"

module OptargInternalBoolHasNotMethodFeature
  class Model < Optarg::Model
    bool "-b", not: "-B"
  end

  it name do
    option = Model.__options["-b"]
    option.responds_to?(:not).should be_true
    if option.responds_to?(:not)
      option.not.should eq %w(-B)
    end
  end
end
