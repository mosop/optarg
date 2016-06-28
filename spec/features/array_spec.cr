require "../spec_helper"

module Optarg::ArrayFeature
  class Model < ::Optarg::Model
    array "-e"
  end

  it "Array" do
    result = Model.parse(%w(-e foo -e bar -e baz))
    result.e.should eq %w(foo bar baz)
  end
end
