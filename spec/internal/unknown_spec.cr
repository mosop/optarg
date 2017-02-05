require "../spec_helper"

module OptargInternalSpec::Unknown
  class Model < Optarg::Model
    string "-s"
    unknown
  end

  describe name do
    it "with option" do
      result = Model.parse(%w(-s foo bar))
      result.s?.should eq "foo"
      result.unparsed_args.should eq %w(bar)
    end

    it "without different option" do
      result = Model.parse(%w(-b foo bar))
      result.unparsed_args.should eq %w(-b foo bar)
    end

    it "without option" do
      result = Model.parse(%w(foo bar))
      result.unparsed_args.should eq %w(foo bar)
    end
  end
end
