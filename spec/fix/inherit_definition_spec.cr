require "../spec_helper"

module OptargFixInheritDefinitionFeature
  class Model < Optarg::Model
    arg "arg"
    string "-s"
    bool "-b"
    on("-h") {}
    terminator "--"
  end

  class Sub < Model
  end

  it name do
    Sub.definitions.all.size.should eq 5
    Sub.definitions.options_and_arguments.size.should eq 3
    Sub.definitions.option_visitors.size.should eq 3
    Sub.definitions.concatenation_visitors.size.should eq 3
    Sub.definitions.value_fallbackers.size.should eq 3
    Sub.definitions.value_validators.size.should eq 3
    Sub.definitions.argument_values.size.should eq 1

    Sub.definitions.all["arg"]?.should_not be_nil
    Sub.definitions.all["-s"]?.should_not be_nil
    Sub.definitions.all["-b"]?.should_not be_nil
    Sub.definitions.all["-h"]?.should_not be_nil
    Sub.definitions.all["--"]?.should_not be_nil
    Sub.definitions.options_and_arguments["arg"]?.should_not be_nil
    Sub.definitions.options_and_arguments["-s"]?.should_not be_nil
    Sub.definitions.options_and_arguments["-b"]?.should_not be_nil
    Sub.definitions.option_visitors["-s"]?.should_not be_nil
    Sub.definitions.option_visitors["-b"]?.should_not be_nil
    Sub.definitions.option_visitors["-h"]?.should_not be_nil
    Sub.definitions.concatenation_visitors["-s"]?.should_not be_nil
    Sub.definitions.concatenation_visitors["-b"]?.should_not be_nil
    Sub.definitions.concatenation_visitors["-h"]?.should_not be_nil
    Sub.definitions.value_fallbackers["arg"]?.should_not be_nil
    Sub.definitions.value_fallbackers["-s"]?.should_not be_nil
    Sub.definitions.value_fallbackers["-b"]?.should_not be_nil
    Sub.definitions.value_validators["arg"]?.should_not be_nil
    Sub.definitions.value_validators["-s"]?.should_not be_nil
    Sub.definitions.value_validators["-b"]?.should_not be_nil
    Sub.definitions.argument_values[0]?.should_not be_nil
  end
end
