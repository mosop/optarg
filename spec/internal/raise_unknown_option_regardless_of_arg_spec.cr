require "../spec_helper"

module OptargInternalRaiseUnknownOptionRegardlessOfArgFeature
  class Model < Optarg::Model
    arg "arg"
  end

  it name do
    expect_raises(Optarg::UnknownOption) { Model.parse %w(--unknown)}
  end
end
