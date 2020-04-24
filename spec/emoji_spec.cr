require "./spec_helper"

def it_emojizes(from, to)
  it "emojizes string '#{from}' to '#{to}'" do
    Emoji.emojize(from).should eq to
  end
end

def it_sanitizes(name, regex : Emoji::RegexType, from, to = "")
  it "sanitizes '#{name}'" do
    Emoji.sanitize(from, regex).should eq to
  end
end

describe "Emoji" do
  it "has version" do
    Emoji::VERSION.should_not be nil
  end

  describe ".emojize" do
    cat = "🐱"
    thumb = "👍"
    love = "❤️"
    crystal = "💎"

    it_emojizes(":cat:s are awesome", "#{cat}s are awesome")
    it_emojizes("Sweet :cat:s", "Sweet #{cat}s")
    it_emojizes("I have a :cat:", "I have a #{cat}")
    it_emojizes("Why :cat:s? 'cause :cat:s rock", "Why #{cat}s? 'cause #{cat}s rock")
    it_emojizes("Talk to your :cat:: say 'meow'", "Talk to your #{cat}: say 'meow'")
    it_emojizes("Who rocks? For sure ::cat:s", "Who rocks? For sure :#{cat}s")

    it_emojizes(":cat:", "#{cat}")
    it_emojizes("::cat::", ":#{cat}:")
    it_emojizes("-:cat:-", "-#{cat}-")
    it_emojizes(" :cat: ", " #{cat} ")
    it_emojizes(": :cat: ", ": #{cat} ")
    it_emojizes(":cat: :", "#{cat} :")
    it_emojizes(":cat  ", ":cat  ")
    it_emojizes(":cat  :", ":cat  :")
    it_emojizes(":cat ::", ":cat ::")
    it_emojizes("cat: :", "cat: :")
    it_emojizes(": :", ": :")
    it_emojizes("::::", "::::")

    it_emojizes(":no_such_emoji:", ":no_such_emoji:")

    it_emojizes(":thumbsup:", "#{thumb}")
    it_emojizes(":+1:", "#{thumb}")

    it_emojizes("I :heart: :gem:", "I #{love} #{crystal}")
    it_emojizes(":gem::cat::+1:", "#{crystal}#{cat}#{thumb}")

    it_emojizes(" Here's a sample:\n:+1:\n\n :gem:", " Here's a sample:\n#{thumb}\n\n #{crystal}")
  end

  describe ".sanitize" do
    it_sanitizes(":soccer:", :simple, "⚽ is cool", " is cool")

    it "does not change regular string" do
      Emoji.sanitize("12 crazy fists!").should eq "12 crazy fists!"
    end

    Emoji::EMOJI_MAP.each do |key, codepoint|
      it_sanitizes(key, :simple, codepoint)
      it_sanitizes(key, :generated, codepoint)
    end
  end
end
