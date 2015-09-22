require "./emoji/*"

module Emoji
  VERSION = "0.1.0"

  @@map = Emoji::EMOJI_MAP

  def self.emojize(s)
    s.scan(/:[^(: )]+?:/).map { |data| data[0] }
      .uniq!
      .each do |name|
        code = @@map[name]?
        s = s.gsub(name, code) if code
      end
    s
  end
end

