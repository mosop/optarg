require "../spec_helper"

module Optarg::SynonymsFeature
  class Model < ::Optarg::Model
    string %w(-f --file)
  end
end

describe "Synonyms" do
  it "" do
    result = Optarg::SynonymsFeature::Model.parse(%w(-f foo.cr))
    result.f.should eq "foo.cr"
    result.file.should eq "foo.cr"
  end
end
