# frozen_string_literal: true

module ModelHealthCheck
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
