require "json"
require "http"

# Sample script to load emoji db.
# Use it in your crystal program as follows:
# ```
# macro load_data
#   data = {{ run("#{path_to_this_file}/emoji_map.cr").id }}
#   puts data[":cat:"]
# end
# load_data
# ```
class JSONEmoji
  json_mapping({
    emoji:       {type: String, nilable: true},
    description: {type: String, nilable: true},
    aliases:     {type: Array(String)},
    tags:        {type: Array(String)}
  })

  def initialize(@emoji : String, @aliases: Array(String))
  end

  def self.load(json)
    json_emojis = Array(JSONEmoji).from_json(json)

    # Generate codepoint map
    codepoint_map = {} of String => String
    json_emojis.each do |json_emoji|
      codepoint = json_emoji.emoji
      if codepoint
        json_emoji.aliases.each do |name|
          codepoint_map[":#{name}:"] = codepoint
        end
      end
    end
    codepoint_map
  end
end

url = "https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json"
response = HTTP::Client.get(url)
puts JSONEmoji.load(response.body)
