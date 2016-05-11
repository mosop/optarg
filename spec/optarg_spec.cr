require "./spec_helper"

module Optarg_
  class Model < ::Optarg::Model
    string "-s"
    bool "-b"
  end

  class Submodel < Model
    string "--string"
    bool "--bool"
  end

  class NegationModel < ::Optarg::Model
    bool "-b", not: "-B"
  end

  class DefaultModel < ::Optarg::Model
    string "--default-string", default: "default"
    bool "--default-bool", default: true, not: "--Default-bool"
  end

  class HandlerModel < ::Optarg::Model
    on("--on") { handle }

    def handle
      raise self.class.name
    end
  end

  class SynonymModel < ::Optarg::Model
    string %w[-s --string]
    bool %w[-b --bool]
  end

  class CustomModel < ::Optarg::Model
    def initialize(argv, @custom : ::String)
      super argv
    end

    on("--custom") { raise @custom }
  end

  class DefaultStringModel < ::Optarg::Model
    string "--string", default: "default"
    bool "--bool", default: true
  end
end

describe Optarg do
  it "-s v -b parsed -- unparsed" do
    argv = %w{-s v -b parsed -- unparsed}
    result = Optarg_::Model.parse(argv)
    result.s.should eq "v"
    result.s?.should eq "v"
    result.b?.should be_true
    result.args.should eq %w(parsed)
    result.unparsed_args.should eq %w(unparsed)
    result.__optarg_parsed_nodes.should eq [%w(-s v), %w(-b), %w(parsed)]
  end

  it "parses nothing" do
    argv = %w{}
    result = Optarg_::Model.parse(argv)
    expect_raises(KeyError) { result.s }
    result.s?.should be_nil
    result.b?.should be_false
    result.args.should eq %w()
    result.unparsed_args.should eq %w()
    result.__optarg_parsed_nodes.should eq [] of Array(String)
  end

  describe "Definition Inheritance" do
    it "-s v -b --string value --bool" do
      argv = %w{-s v -b --string value --bool}
      result = Optarg_::Submodel.parse(argv)
      result.s.should eq "v"
      result.b?.should be_true
      result.string.should eq "value"
      result.bool?.should be_true
    end

    it "does not apply to parent" do
      argv = %w{--string}
      expect_raises(Optarg::UnknownOption) { Optarg_::Model.parse(argv) }
      argv = %w{--bool}
      expect_raises(Optarg::UnknownOption) { Optarg_::Model.parse(argv) }
    end
  end

  describe "Unknown Option" do
    it "--unknown" do
      argv = %w(--unknown)
      expect_raises(Optarg::UnknownOption) { Optarg_::Model.parse(argv) }
    end
  end

  describe "Missing Value" do
    it "-s" do
      argv = %w(-s)
      expect_raises(Optarg::MissingValue) { Optarg_::Model.parse(argv) }
    end
  end

  describe "Negation" do
    it "-B" do
      argv = %w(-B)
      result = Optarg_::NegationModel.parse(argv)
      result.b?.should be_false
    end
  end

  describe "Default Value" do
    it "sets default value" do
      argv = %w()
      result = Optarg_::DefaultModel.parse(argv)
      result.default_string.should eq "default"
      result.default_bool?.should be_true
    end

    it "--default-string notdefault --Default-bool" do
      argv = %w(--default-string notdefault --Default-bool)
      result = Optarg_::DefaultModel.parse(argv)
      result.default_string.should eq "notdefault"
      result.default_bool?.should be_false
    end
  end

  describe "Handler" do
    it "runs block in instance's context" do
      argv = %w(--on)
      expect_raises(::Exception, "Optarg_::HandlerModel") { Optarg_::HandlerModel.parse(argv) }
    end
  end

  describe "Synonyms" do
    it "defines multiple accessors" do
      argv = %w(-s v --bool)
      result = Optarg_::SynonymModel.parse(argv)
      result.responds_to?(:s).should be_true
      result.responds_to?(:string).should be_true
      result.responds_to?(:b?).should be_true
      result.responds_to?(:bool?).should be_true
      result.s.should eq "v" if result.responds_to?(:s)
      result.s.should eq "v" if result.responds_to?(:string)
      result.b?.should be_true if result.responds_to?(:b?)
      result.bool?.should be_true if result.responds_to?(:bool?)
    end
  end

  describe "Custom Initialization" do
    it "accepts self-initializing model" do
      argv = %w(--custom)
      expect_raises(::Exception, "custom") { Optarg_::CustomModel.new(argv, "custom").parse }
    end
  end

  describe "Default String" do
    it "has default string" do
      Optarg_::DefaultStringModel.definitions.options[0].default_string.should eq "default"
      Optarg_::DefaultStringModel.definitions.options[1].default_string.should eq "true"
    end
  end
end
