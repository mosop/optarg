require "../spec_helper"

module OptargArgumentsFeature
  class Model < Optarg::Model
    string "-s"
    bool "-b"
  end

  it name do
    result = Model.parse(%w(foo -s string -b bar baz))
    result.args.should eq %w(foo bar baz)
  end
end
