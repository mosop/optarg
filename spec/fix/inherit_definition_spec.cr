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
    Sub.definitions.arguments.size.should eq 1
    Sub.definitions.options.size.should eq 3
    Sub.definitions.value_options.size.should eq 2
    Sub.definitions.values.size.should eq 3
    Sub.definitions.handlers.size.should eq 1
    Sub.definitions.terminators.size.should eq 1
    Sub.definitions.argument_list.size.should eq 1

    Sub.definitions.all["arg"]?.should_not be_nil
    Sub.definitions.all["-s"]?.should_not be_nil
    Sub.definitions.all["-b"]?.should_not be_nil
    Sub.definitions.all["-h"]?.should_not be_nil
    Sub.definitions.all["--"]?.should_not be_nil
    Sub.definitions.arguments["arg"]?.should_not be_nil
    Sub.definitions.options["-s"]?.should_not be_nil
    Sub.definitions.options["-b"]?.should_not be_nil
    Sub.definitions.options["-h"]?.should_not be_nil
    Sub.definitions.value_options["-s"]?.should_not be_nil
    Sub.definitions.value_options["-b"]?.should_not be_nil
    Sub.definitions.values["arg"]?.should_not be_nil
    Sub.definitions.values["-s"]?.should_not be_nil
    Sub.definitions.values["-b"]?.should_not be_nil
    Sub.definitions.handlers["-h"]?.should_not be_nil
    Sub.definitions.terminators["--"]?.should_not be_nil
    Sub.definitions.argument_list[0]?.should_not be_nil
  end
end
