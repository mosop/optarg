require "../spec_helper"

module OptargInternalNoAccessorFeature
  class ForArguments < ::Optarg::Model
    arg "to_s"
    arg "same"
    arg "unparsed_args"
  end

  class ForOptions < ::Optarg::Model
    string "--to_s"
    bool "--same"
    array "--unparsed_args"
  end

  class ForStringSame < ::Optarg::Model
    string "--same"
  end

  describe name do
    it "args" do
      result = ForArguments.parse(%w())
      model_methods = {{ ForArguments.methods.map{|i| i.name.stringify} }}
      model_methods.includes?("to_s").should be_false
      model_methods.includes?("same?").should be_false
      model_methods.includes?("unparsed_args").should be_false
      args_methods = {{ ForArguments::ArgumentValueContainer.methods.map{|i| i.name.stringify} }}
      args_methods.includes?("to_s").should be_false
      args_methods.includes?("same?").should be_false
      args_methods.includes?("unparsed_args").should be_true
    end

    it "string --to_s, bool --same, array --unparsed_args" do
      result = ForOptions.parse(%w())
      model_methods = {{ ForOptions.methods.map{|i| i.name.stringify} }}
      model_methods.includes?("to_s").should be_false
      model_methods.includes?("same?").should be_false
      model_methods.includes?("unparsed_args").should be_false
      model_methods = {{ ForOptions::OptionValueContainer.methods.map{|i| i.name.stringify} }}
      model_methods.includes?("to_s").should be_false
      model_methods.includes?("same?").should be_false
      model_methods.includes?("unparsed_args").should be_true
    end

    it "string --same" do
      result = ForStringSame.parse(%w())
      model_methods = {{ ForStringSame.methods.map{|i| i.name.stringify} }}
      model_methods.includes?("same?").should be_false
      model_methods = {{ ForStringSame::OptionValueContainer.methods.map{|i| i.name.stringify} }}
      model_methods.includes?("same?").should be_false
    end
  end
end
