require "../spec_helper"

module Emoji
  describe CodepointMap do
    name = ":cat:"
    codepoint = "\u{1f431}"

    describe "#includes?" do
      it "returns true for existed codepoint name" do
        CodepointMap.new.includes?(name).should be_true
      end

      it "returns false for missed codepoint name" do
        CodepointMap.new.includes?(":no_such_codepoint_name:").should be_false
      end
    end

    describe "#[]" do
      it "returns codepoint by codepoint name" do
        CodepointMap.new[name].should eq(codepoint)
      end

      it "raises MissingKey if such codepoint name missed" do
        expect_raises MissingKey do
          CodepointMap.new[":no_such_codepoint_name:"]
        end
      end
    end
  end
end
