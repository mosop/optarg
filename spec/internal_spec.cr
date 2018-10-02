require "./spec_helper"

module OptargInternalFeature
  class ParseModel < Optarg::Model
    string "-s"
    bool "-b"
    arg "arg"
    terminator "--"
  end

  it "-s v -b arg parsed -- unparsed" do
    argv = %w{-s v -b arg parsed -- unparsed}
    result = ParseModel.parse(argv)
    result.arg.should eq "arg"
    result.s.should eq "v"
    result.s?.should eq "v"
    result.b?.should be_true
    result.__parser.parsed_args.should eq %w(arg parsed)
    result[String].should eq({"-s" => "v", "arg" => "arg"})
    result.nameless_args.should eq %w(parsed)
    result.unparsed_args.should eq %w(unparsed)
    result.__parser.parsed_nodes[0].should eq Optarg::Parser.new_node(%w(-s v), ParseModel.__klass.definitions.options["-s"])
    result.__parser.parsed_nodes[1].should eq Optarg::Parser.new_node(%w(-b), ParseModel.__klass.definitions.options["-b"])
    result.__parser.parsed_nodes[2].should eq Optarg::Parser.new_node(%w(arg), ParseModel.__klass.definitions.arguments["arg"])
    result.__parser.parsed_nodes[3].should eq Optarg::Parser.new_node(%w(parsed))
  end

  it "parses nothing" do
    argv = %w{}
    result = ParseModel.parse(argv)
    expect_raises(KeyError) { result.s }
    result.s?.should be_nil
    result.b?.should be_false
    result.nameless_args.should eq %w()
    result.__parser.parsed_args.should eq %w()
    result.unparsed_args.should eq %w()
    result.__parser.parsed_nodes.should eq [] of Array(String)
  end

  class Supermodel < Optarg::Model
    string "-s"
    bool "-b"
  end

  class Submodel < Supermodel
    string "--string"
    bool "--bool"
  end

  class Supermodel2 < Optarg::Model
    arg "arg1"
  end

  class Submodel2 < Supermodel2
    arg "argument"
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
      result.arg1.should eq "foo"
      result.argument.should eq "bar"
    end

    it "does not apply to parent" do
      result = Supermodel2.parse(%w(foo bar))
      result.responds_to?(:argument).should be_false
    end
  end

  class EmptyModel < Optarg::Model
  end

  describe "Unknown Option" do
    it "--unknown" do
      argv = %w(--unknown)
      expect_raises(Optarg::UnknownOption) { EmptyModel.parse(argv) }
    end
  end

  class MissingModel < Optarg::Model
    string "-s"
    array "-a"
  end

  describe "Missing Value" do
    it "-s" do
      argv = %w(-s)
      expect_raises(Optarg::MissingValue, "The -s option has no value") { MissingModel.parse(argv) }
    end

    it "-a" do
      argv = %w(-a)
      expect_raises(Optarg::MissingValue, "The -a option has no value") { MissingModel.parse(argv) }
    end
  end

  class DefaultModel < Optarg::Model
    string "--default-string", default: "default"
    bool "--default-bool", default: true, not: "--Default-bool"
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

  class SynonymsModel < Optarg::Model
    string %w(-s --string)
    bool %w(-b --bool)
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

  class MetadataModel < Optarg::Model
    class Metadata < Optarg::Metadata
      getter :data

      def initialize(@data : ::String)
      end
    end

    string "-s", metadata: Metadata.new("string")
    bool "-b", Metadata.new("bool")
    array "-a", Metadata.new("array")
    arg "arg", metadata: Metadata.new("arg")
    on("--help", metadata: Metadata.new("handler")) {}
    terminator "--", metadata: Metadata.new("terminator")
  end

  describe "Metadata" do
    it "preserves metadata" do
      MetadataModel.__klass.definitions.options["-s"].metadata.as(MetadataModel::Metadata).data.should eq "string"
      MetadataModel.__klass.definitions.options["-b"].metadata.as(MetadataModel::Metadata).data.should eq "bool"
      MetadataModel.__klass.definitions.options["-a"].metadata.as(MetadataModel::Metadata).data.should eq "array"
      MetadataModel.__klass.definitions.arguments["arg"].metadata.as(MetadataModel::Metadata).data.should eq "arg"
      MetadataModel.__klass.definitions.handlers["--help"].metadata.as(MetadataModel::Metadata).data.should eq "handler"
      MetadataModel.__klass.definitions.terminators["--"].metadata.as(MetadataModel::Metadata).data.should eq "terminator"
    end
  end
end
