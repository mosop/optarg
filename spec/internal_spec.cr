require "./spec_helper"

module Optarg::Test
  class Model < ::Optarg::Model
    string "-s"
    bool "-b"
  end

  class Supermodel < ::Optarg::Model
    string "-s"
    bool "-b"
  end

  class Submodel < Supermodel
    string "--string"
    bool "--bool"
  end

  class EmptyModel < ::Optarg::Model
  end

  class DefaultModel < ::Optarg::Model
    string "--default-string", default: "default"
    bool "--default-bool", default: true, not: "--Default-bool"
  end

  class SynonymsModel < ::Optarg::Model
    string %w(-s --string)
    bool %w(-b --bool)
  end

  class MetadataModel < ::Optarg::Model
    class Option
      class Metadata
        getter :data

        def initialize(@data : ::String)
        end
      end
    end

    class Handler
      class Metadata
        getter :data

        def initialize(@data : ::String)
        end
      end
    end

    __define_string_option "-s"
    __define_bool_option "-b"
    __define_string_array_option "-a"
    __define_handler("--help") {}
    __add_string_option "-s", metadata: Options::Option_s::Metadata.new("string")
    __add_bool_option "-b", metadata: Options::Option_b::Metadata.new("bool")
    __add_string_array_option "-a", metadata: Options::Option_a::Metadata.new("array")
    __add_handler "--help", metadata: Handlers::Handler_help::Metadata.new("handler")
  end
end

describe Optarg do
  it "-s v -b parsed -- unparsed" do
    argv = %w{-s v -b parsed -- unparsed}
    result = Optarg::Test::Model.parse(argv)
    result.s.should eq "v"
    result.s?.should eq "v"
    result.b?.should be_true
    result.args.should eq %w(parsed)
    result.unparsed_args.should eq %w(unparsed)
    result.__parsed_nodes.should eq [%w(-s v), %w(-b), %w(parsed)]
  end

  it "parses nothing" do
    argv = %w{}
    result = Optarg::Test::Model.parse(argv)
    expect_raises(KeyError) { result.s }
    result.s?.should be_nil
    result.b?.should be_false
    result.args.should eq %w()
    result.unparsed_args.should eq %w()
    result.__parsed_nodes.should eq [] of Array(String)
  end

  describe "Inheritance" do
    it "-s v -b --string value --bool" do
      argv = %w{-s v -b --string value --bool}
      result = Optarg::Test::Submodel.parse(argv)
      result.s.should eq "v"
      result.b?.should be_true
      result.string.should eq "value"
      result.bool?.should be_true
    end

    it "does not apply to parent" do
      argv = %w{--string}
      expect_raises(Optarg::UnknownOption) { Optarg::Test::Supermodel.parse(argv) }
      argv = %w{--bool}
      expect_raises(Optarg::UnknownOption) { Optarg::Test::Supermodel.parse(argv) }
    end
  end

  describe "Unknown Option" do
    it "--unknown" do
      argv = %w(--unknown)
      expect_raises(Optarg::UnknownOption) { Optarg::Test::EmptyModel.parse(argv) }
    end
  end

  describe "Missing Value" do
    it "-s" do
      argv = %w(-s)
      expect_raises(Optarg::MissingValue) { Optarg::Test::Model.parse(argv) }
    end
  end

  describe "Default Value" do
    it "sets default value" do
      argv = %w()
      result = Optarg::Test::DefaultModel.parse(argv)
      result.default_string.should eq "default"
      result.default_bool?.should be_true
    end

    it "--default-string notdefault --Default-bool" do
      argv = %w(--default-string notdefault --Default-bool)
      result = Optarg::Test::DefaultModel.parse(argv)
      result.default_string.should eq "notdefault"
      result.default_bool?.should be_false
    end
  end

  describe "Synonyms" do
    it "defines multiple accessors" do
      argv = %w(-s v --bool)
      result = Optarg::Test::SynonymsModel.parse(argv)
      result.responds_to?(:s).should be_true
      result.responds_to?(:string).should be_true
      result.responds_to?(:b?).should be_true
      result.responds_to?(:bool?).should be_true
      result.s.should eq "v" if result.responds_to?(:s)
      result.string.should eq "v" if result.responds_to?(:string)
      result.b?.should be_true if result.responds_to?(:b?)
      result.bool?.should be_true if result.responds_to?(:bool?)
    end
  end

  describe "Metadata" do
    it "preserves metadata" do
      Optarg::Test::MetadataModel.__options["-s"].metadata.as(Optarg::Test::MetadataModel::Option::Metadata).data.should eq "string"
      Optarg::Test::MetadataModel.__options["-b"].metadata.as(Optarg::Test::MetadataModel::Option::Metadata).data.should eq "bool"
      Optarg::Test::MetadataModel.__options["-a"].metadata.as(Optarg::Test::MetadataModel::Option::Metadata).data.should eq "array"
      Optarg::Test::MetadataModel.__handlers["--help"].metadata.as(Optarg::Test::MetadataModel::Handler::Metadata).data.should eq "handler"
    end
  end
end
