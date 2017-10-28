# opal-file

native File.read, File.write etc... for Opal

## What is this?

Opal's File class does not have methods for file IO but this module provides them.

This provides...

- `File` (partial; no #open and #new)
- `File::Stat` (partial)
- `FileTest` (partial)
- `Errno::EXXX`

Pull requests are welcome!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opal-file'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opal-file

## Usage

write foo.rb

```ruby
require "opal-file"

puts File.read("./foo")
```

and compile

```bash
opal --gem opal-file foo.rb > foo.js
```

and run!

```bash
node foo.js
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Narazaka/opal-file.

## License

This is released under [MIT License](https://narazaka.net/license/MIT?2017)
