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

<a name="code_samples"></a>

## Code Samples

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

### Inheritance (Reusing Models)

```crystal
abstract class Animal < Optarg::Model
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

Model.parse(%w(--goodbye), The.new) # raises "Someday again!"
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

### Validating Inclusion

```crystal
class Trip < Optarg::Model
  arg "somewhere_warm", any_of: %w(tahiti okinawa hawaii)
end

Trip.parse(%w(gotland)) # => raises an error
```

### Custom Validation

```crystal
class Hello < Optarg::Model
  arg "smiley"

  Parser.on_validate do |parser|
    parser.invalidate! "That's not a smile." if parser.args.smiley != ":)"
  end
end

Hello.parse %w(:P) # => raises "That's not a smile."
```

## Usage

```crystal
require "optarg"
```

and see [Code Samples](#code_samples) and [Wiki](https://github.com/mosop/optarg/wiki).

## Release Notes

See [Releases](https://github.com/mosop/optarg/releases).
