require "../spec_helper"

module OptargSynonymsFeature
  class Model < Optarg::Model
    string %w(-f --file)
  end

  it name do
    result = Model.parse(%w(-f foo.cr))
    result.f.should eq "foo.cr"
    result.file.should eq "foo.cr"
  end
end
