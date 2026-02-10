# frozen_string_literal: true

require "active_support/concern"
require_relative "check"

module ActiveRecord
  module HealthCheck
    module Concern
      extend ActiveSupport::Concern

      def health_check(skips: [])
        Check.new(self, skips: skips).check
      end
    end
  end
end
