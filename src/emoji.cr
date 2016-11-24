require "./emoji/*"

module Emoji
  VERSION = "0.2.0"

  EMOJI_REGEX = /[\x{1f000}-\x{1ffff}\x{2049}-\x{3299}\x{a9}\x{ae}\x{fe0f}\x{203c}]+|[0-9#]\x{fe0f}\x{20e3}/

  @@map = Emoji::EMOJI_MAP

  def self.emojize(s : String)
    s.scan(/:[^(: )]+?:/).map { |data| data[0] }
                         .uniq!
                         .each do |name|
      code = @@map[name]?
      s = s.gsub(name, code) if code
    end
    s
  end

  def self.sanitize(s : String)
    s.gsub(EMOJI_REGEX, "")
  end
end
