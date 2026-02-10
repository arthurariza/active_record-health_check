# frozen_string_literal: true

require_relative "health_check/version"
require_relative "health_check/check"
require_relative "health_check/concern"

module ActiveRecord
  module HealthCheck
    class Error < StandardError; end
  end
end

require_relative "health_check/railtie" if defined?(Rails::Railtie)
