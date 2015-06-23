require "../spec_helper"

module Emoji
  describe EMOJI_MAP do
    name = ":cat:"
    codepoint = "🐱"

    it "has #{name} codepoint name" do
      Emoji::EMOJI_MAP[name].should eq codepoint
    end
  end
end
