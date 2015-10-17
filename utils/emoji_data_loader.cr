require "json"
require "http"

class JSONEmoji
  JSON.mapping({
    emoji:   {type: String, nilable: true},
    aliases: {type: Array(String)},
  })
end

def get_emoji_map(json)
  json_emojis = Array(JSONEmoji).from_json(json)

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

URL = "https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json"
response = HTTP::Client.get URL
puts get_emoji_map response.body
