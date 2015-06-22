require "./emoji/*"

module Emoji
  VERSION = "0.0.1"

  @@map = Emoji::CodepointMap.new

  def self.emojize(s)
    s.scan(/:[\S]+:/).map { |data| data[0] }
      .uniq!
      .each do |name|
        s = s.gsub(name, @@map[name]) if @@map.includes? name
      end
    s
  end
end
