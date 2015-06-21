require "http"
require "json"

class JSONEmoji
  json_mapping({
    emoji:       {type: String, nilable: true},
    description: {type: String, nilable: true},
    aliases:     {type: Array(String)},
    tags:        {type: Array(String)}
  })

  def initialize(@emoji : String, @aliases: Array(String))
  end
end

# Get Emojis data
url = "https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json"
response = HTTP::Client.get(url)
s = response.body
json_emojis = Array(JSONEmoji).from_json(s)

# Generate codepoint map
codepoint_map = {} of String => String
json_emojis.each do |json_emoji|
  emoji = json_emoji.emoji
  if emoji
    name = json_emoji.aliases.first
    codepoint = ""
    emoji.each_char do |char|
      codepoint += "\\u{#{char.ord.to_s(16)}}"
    end
    codepoint_map[name] = codepoint
  end
end

# Generate source file
content = <<-EOT
# DO NOT EDIT THIS FILE MANUALLY.
# IT IS AUTOMATICALLY GENERATED BY code_map_generator.cr
module Emoji
  CODEPOINT_MAP = {

EOT

cm = String.build do |str|
  codepoint_map.keys.sort!.each do |name|
    str << "    \":#{name}:\" => \"#{codepoint_map[name]}\",\n"
  end
  str << <<-EOT
  }
end
EOT
end


File.write("src/emoji/codepoint_map.cr", content + cm)
