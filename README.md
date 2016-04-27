# optarg

Yet another library for parsing command-line options and arguments, written in the Crystal language.

[![Build Status](https://travis-ci.org/mosop/optarg.svg?branch=master)](https://travis-ci.org/mosop/optarg)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  optarg:
    github: mosop/optarg
```

## Features

* Easy Access

  ```crystal
  class Model < Optarg::Model
    string "--foo"
  end

  result = Model.parse(%w(--foo bar))
  result.foo # => "bar"
  ```

* Nilable Accessor

  ```crystal
  class Model < Optarg::Model
    string "--foo"
  end

  result = Model.parse(%w())
  result.foo? # => nil
  result.foo # raises KeyError
  ```

* Synonyms

  ```crystal
  class Model < Optarg::Model
    string %w(-f --file)
  end

  result = Model.parse(%w(-f foo.cr))
  result.f # => "foo.cr"
  result.file # => "foo.cr"
  ```

* Default Value

  ```crystal
  class Model < Optarg::Model
    string "--foo", default: "bar"
  end

  result = Model.parse(%w())
  result.foo # => "bar"
  ```

* Boolean Value

  ```crystal
  class Model < Optarg::Model
    bool "-b"
  end

  result = Model.parse(%w(-b))
  result.b? # => true
  ```

* Negation

  ```crystal
  class Model < Optarg::Model
    bool "-b", not: "-B"
  end

  result = Model.parse(%w(-B))
  result.b? # => false
  ```

* Non-option Arguments

  ```crystal
  class Model < Optarg::Model
    string "-s"
    bool "-b"
  end

  result = Model.parse(%w(-s foo -b bar -- baz))
  result.args # => ["bar"]
  result.unparsed_args # => ["baz"]
  ```

* Inheritance (Reusable Model)

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

  cat = Cat.parse(%w(--sleep --mew))
  dog = Dog.parse(%w(--sleep --woof))
  ```

* Handler

  ```crystal
  class Model < Optarg::Model
    on("--goodbye") { world! }

    def world!
      raise "Goodbye, world!"
    end
  end

  Model.parse %w(--goodbye) # raises "Goodbye, world!"
  ```

## Usage

```crystal
require "optarg"
```

and see Features.

## Releases

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
