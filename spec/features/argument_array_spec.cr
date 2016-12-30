require "../spec_helper"

module OptargArgumentArrayFeature
  class Model < Optarg::Model
    arg "arg"
    arg_array "item"
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    result.arg.should eq "foo"
    result.item.should eq ["bar", "baz"]

    result.args.item.should eq %w(bar baz)
    result.parsed_args.should eq %w(foo bar baz)
  end
end
