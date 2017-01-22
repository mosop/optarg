require "../../spec_helper"

module OptargArgumentValueContainerFeatureDetail
  class Model < Optarg::Model
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    result.nameless_args.size.should eq 3
    result.nameless_args[0].should eq "foo"
    result.nameless_args[1].should eq "bar"
    result.nameless_args[2].should eq "baz"
    result.nameless_args.map{|i| "#{i}!"}.should eq %w(foo! bar! baz!)
  end
end
