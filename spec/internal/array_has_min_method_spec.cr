require "../spec_helper"

module OptargInternalArrayHasMinMethodFeature
  class Model < Optarg::Model
    array "-a", min: 1
  end

  it name do
    option = Model.__options["-a"]
    option.responds_to?(:min).should be_true
    if option.responds_to?(:min)
      option.min.should eq 1
    end
  end
end
