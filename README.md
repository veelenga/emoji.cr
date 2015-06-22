# emoji.cr [![Build Status](https://travis-ci.org/veelenga/emoji.cr.svg?branch=master)](https://travis-ci.org/veelenga/emoji.cr)

Emoji library for Crystal. Inspired by [Emoji for Python](https://github.com/carpedm20/emoji)

## Installation

Add it to `Projectfile`

```crystal
deps do
  github "veelenga/emoji.cr"
end
```

## Usage

```crystal
require "emoji.cr"

puts Emoji.emojize("I like :soccer: and :bicyclist:")
```

## Demo
![](screen/demo.png)

**Note:** to see the result in terminal, you need to install appropriate fonts. I used [ttf-symbola](https://www.archlinux.org/packages/?name=ttf-symbola) on Arch Linux.

## Resources
- [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/)

## Contributing

1. Fork it ( https://github.com/veelenga/emoji.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
