# Generates Crystal source code file.
#
# ```
# crystal this_file_name.cr
# ```

macro generate_source(module_name, emoji_map)
<<-EOT
# THIS IS AUTOMATICALLY GENERATED FILE.
# DO NOT EDIT IT MANUALLY.
#
module {{module_name.id}}
  # Represents an emoji map with the following format:
  #`emoji_name => emoji_itself`
  #
  # ```
  # puts {{module_name.id}}::EMOJI_MAP[":cat:"]? # => 🐱
  # ```
  # **Note**: list of available emoji names you can
  # find [here](http://www.emoji-cheat-sheet.com/).
  EMOJI_MAP = \{{% for name in emoji_map.keys.sort %}
    {{name}} => {{emoji_map[name]}},{% end %}
  }
end
EOT
end

SOURCE_PATH = "src/emoji/emoji_map.cr"
VERBOSE = true

macro create_emoji_map(json_url)
  source = generate_source("Emoji", {{run("./emoji_data_loader.cr", json_url).id}})
  VERBOSE && puts source
  File.write(SOURCE_PATH, source)
  puts "=> FILE GENERATED: #{SOURCE_PATH}"
end

create_emoji_map "https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json"

