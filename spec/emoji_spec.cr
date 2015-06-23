require "./spec_helper"

def it_emojizes(before, after)
  it "emojizes string '#{before}' to '#{after}'" do
    Emoji.emojize(before).should eq after
  end
end

describe "Emoji" do

  it "has version" do
    Emoji::VERSION.should_not be nil
  end

  describe ".emojize" do
    cat     = "🐱"
    thumb   = "👍"
    love    = "❤️"
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
  end
end
