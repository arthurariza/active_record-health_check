# frozen_string_literal: true

module ActiveRecord
  module HealthCheck
    module Skips
      def self.parse(associations = [])
        associations.map(&:to_sym)
      rescue NoMethodError
        raise ArgumentError, "Skips Array must contain only strings or symbols"
      end
    end
  end
end
