# frozen_string_literal: true

RSpec.describe ModelHealthCheck do
  it "has a version number" do
    expect(ModelHealthCheck::VERSION).not_to be nil
  end
end
