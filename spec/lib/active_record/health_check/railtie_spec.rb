# frozen_string_literal: true

require "rails/railtie"
require "active_record/health_check/railtie"

RSpec.describe ActiveRecord::HealthCheck::Railtie do
  it "is a Rails::Railtie subclass" do
    expect(described_class.superclass).to eq(Rails::Railtie)
  end

  it "registers an initializer named 'active_record.health_check'" do
    initializer_names = described_class.initializers.map(&:name)

    expect(initializer_names).to include("active_record.health_check")
  end
end
