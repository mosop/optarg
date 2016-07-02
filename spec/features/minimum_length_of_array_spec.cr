require "../spec_helper"

module Optarg::MinimumLengthOfArrayFeature
  class Multiply < Optarg::Model
    array "-n", min: 2
  end

  it "Minimum Length of Array" do
    expect_raises(Optarg::MinimumLengthError) { Multiply.parse %w(-n 794) }
  end
end
