# optarg

Yet another library for parsing command-line options and arguments, written in the Crystal language.

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
  bool "-b", default: false
  array "-a", default: %w(1 2 3)
end

result = Model.parse(%w())
result.s  # => "string"
result.b? # => false
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

result = Model.parse(%w(-s foo -b bar -- baz))
result.args # => ["bar"]
result.unparsed_args # => ["baz"]
```

### Accessible Argument

```crystal
class Model < Optarg::Model
  arg "src_dir"
  arg "build_dir"
end

result = Model.parse(%w(/path/to/src /path/to/build and more))
result.src_dir # => "/path/to/src"
result.build_dir # => "/path/to/build"
result.args # => ["and", "more"]
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

### Required Options

```crystal
class Profile < Optarg::Model
  string "--birth", required: true

  def run
    puts "birth date: #{options.birth}"
  end
end

Birthday.parse %w() # raises a Required exception.
```

### Minimum Length of Array

```crystal
class Multiply < Optarg::Model
  array "-n", min: 2

  def run
    puts options.n.reduce{|n1, n2| n1 * n2}
  end
end

Multiply.parse %w(-n 794) # raises a MinimumLength exception.
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

## Usage

```crystal
require "optarg"
```

and see [Features](#features).

## Release Notes

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
