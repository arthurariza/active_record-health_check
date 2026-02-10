# frozen_string_literal: true

module ActiveRecord
  module HealthCheck
    class Railtie < Rails::Railtie
      initializer "active_record.health_check" do
        ActiveSupport.on_load(:active_record) do
          include ActiveRecord::HealthCheck::Concern
        end
      end
    end
  end
end
