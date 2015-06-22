require "json"

module Emoji
  macro load_codepoint_map(data)
    # Represents a codepoint map with the following format:
    #`codepoint_name => codepoint`
    #
    # ```
    # codepointMap = CodepointMap.new
    # puts codepointMap.includes?[":cat:"] # => true
    # puts codepointMap[":cat:"]           # => 🐱
    # ```
    # **Note**: list of available codepoint names you can
    # find [here](http://www.emoji-cheat-sheet.com/).
    class CodepointMap
      def initialize(@data = {{data}})
      end

      def [](name: String)
        @data[name]
      end

      def includes?(name: String)
        @data.each do |n|
          return true if n == name
        end
        false
      end
    end
  end

  class JSONEmoji
    json_mapping({
      emoji:       {type: String, nilable: true},
      description: {type: String, nilable: true},
      aliases:     {type: Array(String)},
      tags:        {type: Array(String)}
    })

    def initialize(@emoji : String, @aliases: Array(String))
    end

    def self.load(path)
      json_emojis = Array(JSONEmoji).from_json(File.read(path))

      # Generate codepoint map
      codepoint_map = {} of String => String
      json_emojis.each do |json_emoji|
        codepoint = json_emoji.emoji
        if codepoint
          name = json_emoji.aliases.first
          codepoint_map[":#{name}:"] = codepoint
        end
      end
      codepoint_map
    end
  end

  load_codepoint_map(JSONEmoji.load("emoji/db/emoji.json"))
end
