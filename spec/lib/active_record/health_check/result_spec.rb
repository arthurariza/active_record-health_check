# frozen_string_literal: true

require "./lib/active_record/health_check/result"
require "spec_helper"

RSpec.describe ActiveRecord::HealthCheck::Result do
  describe ".create" do
    it "creates the result and returns the result as a hash" do
      expect(
        described_class.create(klass: "Post", id: 1, error_messages: "Title must be present")
      ).to eq({
                class: "Post",
                id: 1,
                error_messages: "Title must be present"
              })
    end
  end
end
