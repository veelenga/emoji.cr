# emoji.cr [![Build Status](https://travis-ci.org/veelenga/emoji.cr.svg?branch=master)](https://travis-ci.org/veelenga/emoji.cr)

Emoji library for Crystal. Inspired by [Emoji for Python](https://github.com/carpedm20/emoji)

## Installation

As a dependency in `shard.yml`:

```yaml
dependencies:
  emoji:
    github: veelenga/emoji.cr
    branch: master
```

## Usage

```crystal
require "emoji"

puts Emoji.emojize("I :heart: :beer: and :football:")
```

Will print the following in console:

![](assets/screen.png)

Also it is possible to remove all emoji from the string:

```crystal
str = Emoji.emojize("Girl on :fire:")
Emoji.sanitize(str) #=> "Girl on "
```

### Binary

You may also compile and use `emojize` binary that just prints to console emojized string:

```sh
$ crystal build bin/emojize
$ ./emojize It will boom: :boom:
```

![](assets/boom.png)


## Resources
- [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/)

## Contributing

1. Fork it ( https://github.com/veelenga/emoji.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
