# frozen_string_literal: true

module ActiveRecord
  module HealthCheck
    class Result
      def self.create(klass:, id:, error_messages:)
        {
          class: klass,
          id: id,
          error_messages: error_messages
        }
      end
    end
  end
end
