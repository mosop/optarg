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
    Sub.__klass.definitions.all.size.should eq 5
    Sub.__klass.definitions.arguments.size.should eq 1
    Sub.__klass.definitions.options.size.should eq 3
    Sub.__klass.definitions.value_options.size.should eq 2
    Sub.__klass.definitions.values.size.should eq 3
    Sub.__klass.definitions.handlers.size.should eq 1
    Sub.__klass.definitions.terminators.size.should eq 1
    Sub.__klass.definitions.argument_list.size.should eq 1

    Sub.__klass.definitions.all["arg"]?.should_not be_nil
    Sub.__klass.definitions.all["-s"]?.should_not be_nil
    Sub.__klass.definitions.all["-b"]?.should_not be_nil
    Sub.__klass.definitions.all["-h"]?.should_not be_nil
    Sub.__klass.definitions.all["--"]?.should_not be_nil
    Sub.__klass.definitions.arguments["arg"]?.should_not be_nil
    Sub.__klass.definitions.options["-s"]?.should_not be_nil
    Sub.__klass.definitions.options["-b"]?.should_not be_nil
    Sub.__klass.definitions.options["-h"]?.should_not be_nil
    Sub.__klass.definitions.value_options["-s"]?.should_not be_nil
    Sub.__klass.definitions.value_options["-b"]?.should_not be_nil
    Sub.__klass.definitions.values["arg"]?.should_not be_nil
    Sub.__klass.definitions.values["-s"]?.should_not be_nil
    Sub.__klass.definitions.values["-b"]?.should_not be_nil
    Sub.__klass.definitions.handlers["-h"]?.should_not be_nil
    Sub.__klass.definitions.terminators["--"]?.should_not be_nil
    Sub.__klass.definitions.argument_list[0]?.should_not be_nil
  end
end
