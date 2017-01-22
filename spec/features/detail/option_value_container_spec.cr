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
    result[String].should eq s
    result[Bool].should eq b
    result[Array(String)].should eq a
  end

  module KeyForMultipleName
    class Model < Optarg::Model
      bool %w(-f --force)
    end

    it name do
      result = Model.parse(%w(--force))
      result[Bool]["-f"].should be_true
      expect_raises(KeyError) { result[Bool]["--force"] }
    end
  end
end
