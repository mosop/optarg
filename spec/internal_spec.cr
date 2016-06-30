require "./spec_helper"

module Optarg::Test
  class Model < ::Optarg::Model
    string "-s"
    bool "-b"
    arg "arg"
  end

  class Supermodel < ::Optarg::Model
    string "-s"
    bool "-b"
  end

  class Submodel < Supermodel
    string "--string"
    bool "--bool"
  end

  class Supermodel2 < ::Optarg::Model
    arg "arg"
  end

  class Submodel2 < Supermodel2
    arg "argument"
  end

  class EmptyModel < ::Optarg::Model
  end

  class MissingModel < ::Optarg::Model
    string "-s"
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

    class Argument
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
    __define_argument "arg"
    __define_handler("--help") {}
    __add_string_option "-s", metadata: Options::Option_s::Metadata.new("string")
    __add_bool_option "-b", metadata: Options::Option_b::Metadata.new("bool")
    __add_string_array_option "-a", metadata: Options::Option_a::Metadata.new("array")
    __add_argument "arg", metadata: Arguments::Argument_arg::Metadata.new("arg")
    __add_handler "--help", metadata: Handlers::Handler_help::Metadata.new("handler")

    def self.string_option_metadata_class
      __option_metadata_class_of "-s"
    end

    def self.bool_option_metadata_class
      __option_metadata_class_of "-b"
    end

    def self.string_array_option_metadata_class
      __option_metadata_class_of "-a"
    end

    def self.argument_metadata_class
      __argument_metadata_class_of "arg"
    end

    def self.handler_metadata_class
      __handler_metadata_class_of "--help"
    end
  end

  it "-s v -b arg parsed -- unparsed" do
    argv = %w{-s v -b arg parsed -- unparsed}
    result = Model.parse(argv)
    result.arg.should eq "arg"
    result.s.should eq "v"
    result.s?.should eq "v"
    result.b?.should be_true
    result.args.should eq %w(parsed)
    result.unparsed_args.should eq %w(unparsed)
    result.__parsed_nodes.should eq [%w(-s v), %w(-b), %w(arg), %w(parsed)]
  end

  it "parses nothing" do
    argv = %w{}
    result = Model.parse(argv)
    expect_raises(KeyError) { result.s }
    result.s?.should be_nil
    result.b?.should be_false
    result.args.should eq %w()
    result.unparsed_args.should eq %w()
    result.__parsed_nodes.should eq [] of Array(String)
  end

  describe "Inheritance 1" do
    it "inherits options" do
      argv = %w{-s v -b --string value --bool}
      result = Submodel.parse(argv)
      result.s.should eq "v"
      result.b?.should be_true
      result.string.should eq "value"
      result.bool?.should be_true
    end

    it "does not apply to parent" do
      argv = %w{--string}
      expect_raises(Optarg::UnknownOption) { Supermodel.parse(argv) }
      argv = %w{--bool}
      expect_raises(Optarg::UnknownOption) { Supermodel.parse(argv) }
    end
  end

  describe "Inheritance 2" do
    it "inherits arguments" do
      argv = %w(foo bar)
      result = Submodel2.parse(argv)
      result.arg.should eq "foo"
      result.argument.should eq "bar"
    end

    it "does not apply to parent" do
      result = Supermodel2.parse(%w(foo bar))
      result.responds_to?(:argument).should be_false
      result.arg.should eq "foo"
      result.args.should eq %w(bar)
    end
  end

  describe "Unknown Option" do
    it "--unknown" do
      argv = %w(--unknown)
      expect_raises(Optarg::UnknownOption) { EmptyModel.parse(argv) }
    end
  end

  describe "Missing Value" do
    it "-s" do
      argv = %w(-s)
      expect_raises(Optarg::MissingValue) { MissingModel.parse(argv) }
    end
  end

  describe "Default Value" do
    it "sets default value" do
      argv = %w()
      result = DefaultModel.parse(argv)
      result.default_string.should eq "default"
      result.default_bool?.should be_true
    end

    it "--default-string notdefault --Default-bool" do
      argv = %w(--default-string notdefault --Default-bool)
      result = DefaultModel.parse(argv)
      result.default_string.should eq "notdefault"
      result.default_bool?.should be_false
    end
  end

  describe "Synonyms" do
    it "defines multiple accessors" do
      argv = %w(-s v --bool)
      result = SynonymsModel.parse(argv)
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
      MetadataModel.__options["-s"].metadata.as(MetadataModel::Option::Metadata).data.should eq "string"
      MetadataModel.__options["-b"].metadata.as(MetadataModel::Option::Metadata).data.should eq "bool"
      MetadataModel.__options["-a"].metadata.as(MetadataModel::Option::Metadata).data.should eq "array"
      MetadataModel.__arguments["ARG"].metadata.as(MetadataModel::Argument::Metadata).data.should eq "arg"
      MetadataModel.__handlers["--help"].metadata.as(MetadataModel::Handler::Metadata).data.should eq "handler"
    end

    it "gets metadata class" do
      (MetadataModel.string_option_metadata_class == MetadataModel::Options::Option_s::Metadata).should be_true
      (MetadataModel.bool_option_metadata_class == MetadataModel::Options::Option_b::Metadata).should be_true
      (MetadataModel.string_array_option_metadata_class == MetadataModel::Options::Option_a::Metadata).should be_true
      (MetadataModel.argument_metadata_class == MetadataModel::Arguments::Argument_arg::Metadata).should be_true
      (MetadataModel.handler_metadata_class == MetadataModel::Handlers::Handler_help::Metadata).should be_true
    end
  end
end
