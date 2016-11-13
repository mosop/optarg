# optarg

Yet another Crystal library for parsing command-line options and arguments.

optarg is good enough for parsing options. However there's no feature for formatting help, subcommands... etc. If you prefer a more feature-rich library, try [cli](https://github.com/mosop/cli).

[![Build Status](https://travis-ci.org/mosop/optarg.svg?branch=master)](https://travis-ci.org/mosop/optarg)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  optarg:
    github: mosop/optarg
```

## Features

<a name="features"></a>

### Accessor

```crystal
class Model < Optarg::Model
  string "--foo"
end

result = Model.parse(%w(--foo bar))
result.foo # => "bar"
```

### Nilable Accessor

```crystal
class Model < Optarg::Model
  string "--foo"
end

result = Model.parse(%w())
result.foo? # => nil
result.foo # raises KeyError
```

### Synonyms

```crystal
class Model < Optarg::Model
  string %w(-f --file)
end

result = Model.parse(%w(-f foo.cr))
result.f # => "foo.cr"
result.file # => "foo.cr"
```

### Boolean

```crystal
class Model < Optarg::Model
  bool "-b"
end

result = Model.parse(%w(-b))
result.b? # => true
```

### Array

```crystal
class Model < Optarg::Model
  array "-e"
end

result = Model.parse(%w(-e foo -e bar -e baz))
result.e # => ["foo", "bar", "baz"]
```

### Concatenation

```crystal
class Model < Optarg::Model
  bool "-a"
  bool "-b"
end

result = Model.parse(%w(-ab))
result.a? # => true
result.b? # => true
```

### Default Value

```crystal
class Model < Optarg::Model
  string "-s", default: "string"
  bool "-b", default: true
  array "-a", default: %w(1 2 3)
end

result = Model.parse(%w())
result.s  # => "string"
result.b? # => true
result.a  # => ["1", "2", "3"]
```

### Negation

```crystal
class Model < Optarg::Model
  bool "-b", default: true, not: "-B"
end

result = Model.parse(%w(-B))
result.b? # => false
```

### Arguments

```crystal
class Model < Optarg::Model
  string "-s"
  bool "-b"
end

result = Model.parse(%w(foo -s string bar -b baz))
result.args # => ["foo", "bar", "baz"]
```

### Named Arguments

```crystal
class Model < Optarg::Model
  arg "src_dir"
  arg "build_dir"
end

result = Model.parse(%w(/path/to/src /path/to/build and more))
result.args.src_dir # => "/path/to/src"
result.args.build_dir # => "/path/to/build"
result.args # => ["/path/to/src", "/path/to/build", "and", "more"]
result.named_args # => {"src_dir" => "/path/to/src", "build_dir" => "/path/to/build"}
result.nameless_args # => ["and", "more"]
```

### Inheritance (Reusable Model)

```crystal
class Animal < Optarg::Model
  bool "--sleep"
end

class Cat < Animal
  bool "--mew"
end

class Dog < Animal
  bool "--woof"
end

Cat.parse(%w()).responds_to?(:sleep?) # => true
Dog.parse(%w()).responds_to?(:sleep?) # => true
```

### Handler

```crystal
class Model < Optarg::Model
  on("--goodbye") { goodbye! }

  def goodbye!
    raise "Goodbye, world!"
  end
end

Model.parse %w(--goodbye) # raises "Goodbye, world!"
```

### Required Arguments and Options

```crystal
class Profile < Optarg::Model
  string "--birthday", required: true
end

Profile.parse %w() # raises a RequiredOptionError exception.
```

```crystal
class Compile < Optarg::Model
  arg "source_file", required: true
end

Compile.parse %w() # raises a RequiredArgumentError exception.
```

### Minimum Length of Array

```crystal
class Multiply < Optarg::Model
  array "-n", min: 2

  def run
    puts options.n.reduce{|n1, n2| n1 * n2}
  end
end

Multiply.parse %w(-n 794) # raises a MinimumLengthError exception.
```

### Custom Initializer

```crystal
class The
  def message
    "Someday again!"
  end
end

class Model < Optarg::Model
  def initialize(argv, @the : The)
    super argv
  end

  on("--goodbye") { raise @the.message }
end

Model.new(%w(--goodbye), The.new).parse # raises "Someday again!"
```

### Stop and Termination

```crystal
class Model < Optarg::Model
  bool "-b", stop: true
end

result = Model.parse(%w(foo -b bar))
result.b? # => true
result.args # => ["foo"]
result.unparsed_args # => ["bar"]
```

```crystal
class Model < Optarg::Model
  terminator "--"
end

result = Model.parse(%w(foo -- bar))
result.args # => ["foo"]
result.unparsed_args # => ["bar"]
```

## Usage

```crystal
require "optarg"
```

and see [Features](#features).

## Accessing Parsed Values

### Value Container

A value container is an object for storing parsed values. A value container is one of the following types:

* [Argument Value Container](#argument_value_container)
* [Option Value Container](#option_value_container)
* [Named Argument Value Hash](#named_argument_value_hash)
* [Nameless Argument Value Array](#nameless_argument_value_array)
* [Parsed Argument Value Array](#parsed_argument_value_array)
* [Unparsed Argument Value Array](#unparsed_argument_value_array)

#### Argument Value Container

<a name="argument_value_container"></a>

An argument value container is an Array-like object that contains argument values of a model object.

To access argument value containers, use the `Optarg::Model#args` method.

```crystal
class Model < Optarg::Model
end

result = Model.parse(%w(foo bar baz))
result.args.size # => 3
result.args[0] # => "foo"
result.args[1] # => "bar"
result.args[2] # => "baz"
result.args.map{|i| "#{i}!"} # => ["foo!", "bar!", "baz!"]
```

#### Option Value Container

<a name="option_value_contianer"></a>

An option value container is a set of Hash objects that contains option values of a model object.

Every option value container has 3 hashes. Each hash is one of the following types:

* String
* Bool
* Array(String)

To access option value container, use the `Optarg::Model#options` method.

To access the hashes, use the option value container's `#[]` method with a target type.

```crystal
class Model < Optarg::Model
  string "-s"
  bool "-b"
  array "-a"
end

result = Model.parse(%w(-s foo -b -a bar -a baz))
result.options[String] # => {"-s" => "foo"}
result.options[Bool] # => {"-b" => true}
result.options[Array(String)] # => {"-a" => ["bar", "baz"]}
```

##### Key for Multiple Names

If an option has multiple names, only the first name can be used as a hash key.

```crystal
class Model < Optarg::Model
  bool %w(-f --force)
end

result = Model.parse(%w(--force))
result.options[Bool]["-f"] # => true
result.options[Bool]["--force"] # raises KeyError
```

#### Named Argument Value Hash

<a name="named_argument_value_hash"></a>

A named argument value hash is a Hash object that contains named argument values of a model object.

To access named argument value hashes, use the `Optarg::Model#named_args` method.

```crystal
class Model < Optarg::Model
  arg "named"
end

result = Model.parse(%w(foo bar baz))
result.named_args # => {"named" => "foo"}
```

#### Nameless Argument Value Array

<a name="nameless_argument_value_array"></a>

A nameless argument value array is an Array object that contains nameless argument values of a model object.

To access nameless argument value arrays, use the `Optarg::Model#nameless_args` method.

```crystal
class Model < Optarg::Model
  arg "named"
end

result = Model.parse(%w(foo bar baz))
result.nameless_args # => ["bar", "baz"]
```

#### Parsed Argument Value Array

<a name="parsed_argument_value_array"></a>

A parsed argument value array is an Array object that contains parsed argument values of a model object, regardless of named or nameless.

To access parsed argument value arrays, use the `Optarg::Model#parsed_args` method.

```crystal
class Model < Optarg::Model
  arg "named"
end

result = Model.parse(%w(foo bar baz))
result.parsed_args # => ["foo", "bar", "baz"]
```

Parsed argument value arrays are very similar to argument value containers in enumeration functionality. They are different in that an argument value container is an Array-like object and provides value accessors, whereas a parsed argument value array is just an Array object.

#### Unparsed Argument Value Array

<a name="unparsed_argument_value_array"></a>

An unparsed argument value array is an Array object that contains unparsed argument values of a model object.

To access unparsed argument value arrays, use the `Optarg::Model#unparsed_args` method.

```crystal
class Model < Optarg::Model
  arg "stopper", stop: true
end

result = Model.parse(%w(foo bar baz))
result.unparsed_args # => ["bar", "baz"]
```

### Value Accessor

A value accessor is a method to get a named value. A named value is a value of either an option or a named argument.

Value accessors are automatically defined in model objects and value containers.

The name of a value accessor is determined by the name of a corresponding option or argument. Any leading dash signs (`-`) are eliminated and the other dashes are converted to underscore letters (`_`). For example, `--option-name` is converted to `option_name`.

A value accessor is one of the following types:

* [String Option Value Accessor](#string_option_value_accessor)
* [Bool Option Value Accessor](#bool_option_value_accessor)
* [String-Array Option Value Accessor](#string-array_option_value_accessor)
* [Named Argument Value Accessor](#named_argument_value_accessor)

#### String Option Value Accessor

<a name="string_option_value_accessor"></a>

A string option value accessor is a method to get a string option's value.

For a string option, a nilable value accessor is also defined. If a value is not set, the nilable value accessor returns nil instead raises an exception. The name of a nilable value accessor has a trailing `?` character.

String option value accessors are defined in model objects and option value containers.

```crystal
class Model < Optarg::Model
  string "-s"
end

result = Model.parse(%w(-s value))
result.s # => "value"
result.options.s # equivalent to result.s

not_set = Model.parse(%w())
not_set.s # raises KeyError
not_set.s? # => nil
not_set.options.s # equivalent to not_set.s
not_set.options.s? # equivalent to not_set.s?
```

#### Bool Option Value Accessor

<a name="bool_option_value_accessor"></a>

A bool option value accessor is a method to get a bool option's value.

The name of a bool option value accessor has a trailing `?` character.

If a value is not set, a bool option value accessor returns false.

Bool option value accessors are defined in model objects and option value containers.

```crystal
class Model < Optarg::Model
  bool "-b"
end

result = Model.parse(%w(-b))
result.b? # => true
result.options.b? # equivalent to result.b?

not_set = Model.parse(%w())
not_set.b? # => false
not_set.options.b? # equivalent to not_set.b?
```

#### String-Array Option Value Accessor

<a name="string-array_option_value_accessor"></a>

A string-array option value accessor is a method to get an string-array option's value.

String-array option value accessors are defined in model objects and option value containers.

```crystal
class Model < Optarg::Model
  array "-a"
end

result = Model.parse(%w(-a foo -a bar -a baz))
result.a # => ["foo", "bar", "baz"]
result.options.a # equivalent to result.a
```

#### Named Argument Value Accessor

<a name="named_argument_value_accessor"></a>

A named argument value accessor is a method to get a named argument's value.

For a named argument, a nilable value accessor is also defined. If a value is not set, the nilable value accessor returns nil instead raises an exception. The name of a nilable value accessor has a trailing `?` character.

Named argument value accessors are defined in model objects and argument value containers.

```crystal
class Model < Optarg::Model
  arg "arg1"
  arg "arg2"
end

result = Model.parse(%w(foo bar))
result.arg1 # => "foo"
result.arg2 # => "bar"
result.args.arg1 # equivalent to result.arg1
result.args.arg2 # equivalent to result.arg2
```

#### Avoiding Overriding Methods

If an accessor's name is used for any methods that are already defined, the accessor won't be defined and the predefined method won't be overridden.

For model objects (`Optarg::Model`), all the methods of its ancestor classes (`Reference` and `Object`) and the following methods are not overridden:

* args
* named_args
* nameless_args
* options
* parse
* parsed_args
* parser
* unparsed_args

For argument value container objects (`Optarg::ArgumentValueContainer`) and option value container objects (`Optarg::OptionValueContainer`), all the methods of its ancestor classes (`Reference` and `Object`) are not overridden.

```crystal
class Model < Optarg::Model
  string "--class"
end

result = Model.parse(%w(--class foo))
result.class # => Model
result.options[String]["--class"] # => "foo"
```

## Want to Do

* Validation
  * Inclusion
  * Custom Handler

## Release Notes

* v0.4.0
  * (Breaking Change) Removed Model#args.named Model#args.nameless. Use Model#named_args, Model#nameless_args instead.
  * Argument Value Container
  * Option Value Container
* v0.3.0
  * Stop and Termination
  * (Breaking Change) "--" (double dash) is no longer a special argument by default. Use the `Model.terminator` method.
* v0.2.0
  * (Breaking Change) Model#args separates arguments into named and nameless. #args itself returns both named and nameless arguments.
* v0.1.14
  * Required Arguments and Options
  * Minimum Length of Array
* v0.1.13
  * Accessible Argument
* v0.1.12
  * Array
* v0.1.9
  * Concatenation
* v0.1.3
  * Custom Initializer
* v0.1.2
  * Synonyms
* v0.1.1
  * Handler

## Development

[WIP]

## Contributing

1. Fork it ( https://github.com/mosop/optarg/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [mosop](https://github.com/mosop) - creator, maintainer
