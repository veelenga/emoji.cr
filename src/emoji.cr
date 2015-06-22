require "./emoji/*"

module Emoji
  VERSION = "0.0.1"

  @@codepoint_map = Emoji::CodepointMap.new

  def self.emojize(s)
    s.scan(/:[\S]+:/).uniq do |matched_data|
      matched_data[0]
    end.each do |matched_data|
      codepoint_name = matched_data[0]
      if @@codepoint_map.includes?(codepoint_name)
        s = s.gsub(codepoint_name, @@codepoint_map[codepoint_name])
      end
    end
    s
  end
end
