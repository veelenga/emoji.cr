require "../spec_helper"

module Emoji
  describe CodepointMap do
    describe "#include?" do
      it "returns true for existed codename" do
        CodepointMap.new.includes?(":cat:").should be_true
      end

      it "returns false for missed codename" do
        CodepointMap.new.includes?(":no_such_codepoint_name:").should be_false
      end
    end

    describe "#[]" do
      it "returns codepoint if such name exists" do
        CodepointMap.new[":cat:"].should_not be nil
      end

      it "raises exeception otherwise" do
        expect_raises MissingKey do
          CodepointMap.new[":no_such_codepoint_name:"]
        end
      end
    end
  end
end
