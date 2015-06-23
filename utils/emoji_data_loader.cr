require "json"
require "http"

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

def load(json)
  json_emojis = Array(JSONEmoji).from_json(json)

  # Generate emoji map
  emoji_map = {} of String => String
  json_emojis.each do |json_emoji|
    emoji = json_emoji.emoji
    if emoji
      json_emoji.aliases.each do |name|
        emoji_map[":#{name}:"] = emoji
      end
    end
  end
  emoji_map
end

response = HTTP::Client.get(ARGV[0])
puts load(response.body)
