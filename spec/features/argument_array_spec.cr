require "../spec_helper"

module OptargArgumentArrayFeature
  class Model < Optarg::Model
    arg_array "arg"
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    result.args.arg.should eq %w(foo bar baz)
    result.parsed_args.should eq %w(foo bar baz)
  end
end
