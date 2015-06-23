require "json"

module Emoji
  macro load_codepoint_map()
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
      def initialize(@data = {{ run("../../utils/emoji_map.cr").id }})
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
  load_codepoint_map
end
