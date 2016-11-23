require "../spec_helper"

module OptargMinimumLengthOfArrayFeature
  class Multiply < Optarg::Model
    array "-n", min: 2
  end

  it name do
    expect_raises(Optarg::Definitions::StringArrayOption::Validations::MinimumLength::Error) { Multiply.parse %w(-n 794) }
  end
end
