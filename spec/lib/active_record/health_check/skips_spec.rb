# frozen_string_literal: true

require "./lib/active_record/health_check/skips"

RSpec.describe ActiveRecord::HealthCheck::Skips do
  describe ".parse" do
    it "parses an array of strings to symbols" do
      expect(described_class.parse(["posts"])).to eq([:posts])
    end

    it "parses an array of symbols to symbols" do
      expect(described_class.parse([:posts])).to eq([:posts])
    end

    it "raises ArgumentError when array contains classes other than string or symbols" do
      expect do
        described_class.parse([3])
      end.to raise_error(ArgumentError, "Skips Array must contain only strings or symbols")
    end
  end
end
