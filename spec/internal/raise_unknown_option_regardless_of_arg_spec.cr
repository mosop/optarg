require "../spec_helper"

module OptargRaiseUnknownOptionRegardlessOfArgFeature
  class Model < Optarg::Model
    arg "arg"
  end

  it name do
    expect_raises(Optarg::UnknownOption) { Model.parse %w(--unknown)}
  end
end
