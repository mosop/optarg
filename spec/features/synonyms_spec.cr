require "../spec_helper"

module Optarg::SynonymsFeature
  class Model < ::Optarg::Model
    string %w(-f --file)
  end
end

describe "Features" do
  it "Synonyms" do
    result = Optarg::SynonymsFeature::Model.parse(%w(-f foo.cr))
    result.f.should eq "foo.cr"
    result.file.should eq "foo.cr"
  end
end
