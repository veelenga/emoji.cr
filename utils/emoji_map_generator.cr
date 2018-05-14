# Generates Crystal source code file.
#
# ```
# crystal this_file_name.cr
# ```
require "option_parser"

macro generate_source(module_name, emoji_map)
<<-EOT
# THIS IS AN AUTOMATICALLY GENERATED FILE.
#
# DO NOT EDIT IT MANUALLY.
#
module {{module_name.id}}
  # Represents an emoji map:
  #
  # ```
  # p {{module_name.id}}::EMOJI_MAP[":cat:"]? # => 🐱
  # ```
  # **Note**: list of available emojis you can find at
  # [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/).

  EMOJI_MAP = \{{% for name in emoji_map.keys.sort %}
                {{name}} => {{emoji_map[name]}},{% end %}
  }
end
EOT
end

macro create_source_file(path, verbose)
  source = generate_source("Emoji", {{run("./emoji_data_loader.cr").id}})
  puts source if {{ verbose }}
  File.write({{path}}, source)
  puts "=> FILE GENERATED: #{ {{ path }} }"
end

USAGE = <<-USAGE
Usage: emoji_map_generator [option]
Option:
    --path {filepath}      path of source file to generate
    --verbose, -v          verbose output
    --help, -h             show this help
USAGE

path = "src/emoji/emoji_map.cr"
verbose = false

OptionParser.parse ARGV do |opts|
  opts.on "-h", "--help" do
    puts USAGE
    exit 0
  end

  opts.on "-v", "--verbose" do
    verbose = true
  end

  opts.on "-p", "--path" do |p|
    path = p
  end
end

create_source_file path, verbose
