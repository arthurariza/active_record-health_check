# frozen_string_literal: true

require_relative "result"

module ActiveRecord
  module HealthCheck
    class Check
      def initialize(model, skips: [], collection_result: [], result: Result)
        @model = model
        @skips = skips
        @collection_result = collection_result
        @result = result
      end

      def call
        validate_model

        validate_associations

        @collection_result
      end

      private

      def validate_model
        return if @model.valid?

        @collection_result << @result.create(klass: @model.class.name,
                                             id: @model.id,
                                             error_messages: @model.errors.full_messages.to_sentence)
      end

      def validate_associations
        association_keys.each do |key|
          association = @model.try(key.to_sym)

          next if association.nil?

          validation_factory(association)
        end
      end

      def validation_factory(association)
        case association
        when ActiveRecord::Associations::CollectionProxy
          validate_collection_proxy(association)
        when ActiveRecord::Base
          validate_single_record(association)
        else
          validate_unknown(association)
        end
      end

      def validate_collection_proxy(association)
        association.each do |collection|
          next if collection.valid?

          @collection_result << @result.create(klass: collection.class.name,
                                               id: collection.id,
                                               error_messages: collection.errors.full_messages.to_sentence)
        end
      end

      def validate_single_record(association)
        return if association.valid?

        @collection_result << @result.create(klass: association.class.name,
                                             id: association.id,
                                             error_messages: association.errors.full_messages.to_sentence)
      end

      def validate_unknown(association)
        @collection_result << @result.create(klass: association.class.name,
                                             id: association.id,
                                             error_messages: "Unexpected association type: #{association.class.name}")
      end

      def association_keys
        @association_keys ||= @model._reflections.keys - @skips
      end
    end
  end
end
