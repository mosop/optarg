require "../../spec_helper"

module OptargOptionValueContainerFeatureDetail
  class Model < Optarg::Model
    string "-s"
    bool "-b"
    array "-a"
  end

  it name do
    result = Model.parse(%w(-s foo -b -a bar -a baz))
    s = {"-s" => "foo"}
    b = {"-b" => true}
    a = {"-a" => ["bar", "baz"]}
    result.options[String].should eq s
    result.options[Bool].should eq b
    result.options[Array(String)].should eq a
  end

  module KeyForMultipleName
    class Model < Optarg::Model
      bool %w(-f --force)
    end

    it name do
      result = Model.parse(%w(--force))
      result.options[Bool]["-f"].should be_true
      expect_raises(KeyError) { result.options[Bool]["--force"] }
    end
  end
end
