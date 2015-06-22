require "./spec_helper"

def it_emojizes(actual, expected)
  it "emojizes string '#{actual}' to '#{expected}'" do
    Emoji.emojize(actual).should eq expected
  end
end

describe "Emoji" do

  it "has version" do
    Emoji::VERSION.should_not be nil
  end

  describe ".emojize" do
    cat  = "🐱"

    it_emojizes(":cat:", "#{cat}")
    it_emojizes(":cat:s are awesome", "#{cat}s are awesome")
    it_emojizes("Sweet :cat:s", "Sweet #{cat}s")
    it_emojizes("I have a :cat:", "I have a #{cat}")
    it_emojizes("Why :cat:s? 'cause :cat:s rock", "Why #{cat}s? 'cause #{cat}s rock")

    it_emojizes(":thumbsup:", "👍")
    it_emojizes(":+1:", "👍")

    it_emojizes("I :heart: :gem:", "I ❤️ 💎")
  end
end
