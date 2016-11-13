require "../../spec_helper"

module OptargArgumentValueContainerFeatureDetail
  class Model < Optarg::Model
  end

  it name do
    result = Model.parse(%w(foo bar baz))
    result.args.size.should eq 3
    result.args[0].should eq "foo"
    result.args[1].should eq "bar"
    result.args[2].should eq "baz"
    result.args.map{|i| "#{i}!"}.should eq %w(foo! bar! baz!)
  end
end
