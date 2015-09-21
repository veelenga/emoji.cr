# emoji.cr [![Build Status](https://travis-ci.org/veelenga/emoji.cr.svg?branch=master)](https://travis-ci.org/veelenga/emoji.cr)

Emoji library for Crystal. Inspired by [Emoji for Python](https://github.com/carpedm20/emoji)

## Installation

As a dependency in `shards.yml`:

```yaml
dependencies:
  emoji:
    github: veelenga/emoji.cr
    branch: master
```

## Usage

```crystal
require "emoji"

Emoji.emojize("I :heart: :gem:") # => "I ❤️ 💎"
```

## Resources
- [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/)

## Contributing

1. Fork it ( https://github.com/veelenga/emoji.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
