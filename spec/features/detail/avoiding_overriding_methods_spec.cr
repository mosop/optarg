require "../../spec_helper"

module OptargAvoidingOverridingMethodsFeatureDetail
  class Model < Optarg::Model
    string "--class"
  end

  it name do
    result = Model.parse(%w(--class foo))
    result.class.should eq Model
    result[String]["--class"].should eq "foo"
  end
end
