require "../spec_helper"

module Emoji
  describe EMOJI_MAP do
    it "has #{name} codepoint name" do
      Emoji::EMOJI_MAP[":cat:"].should eq "🐱"
    end
  end
end
