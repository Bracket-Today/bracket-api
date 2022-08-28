# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def create_resource key, resource
      if resource.save
        { key => resource, :errors => [] }
      else
        { key => nil, :errors => errors_for(resource) }
      end
    end

    def update_resource key, resource, attributes
      process_resource(key, resource) do
        resource.update(attributes)
      end
    end

    def destroy_resource key, resource
      process_resource(key, resource, &:destroy)
    end

    def process_resource key, resource
      if yield(resource)
        { key => resource, :errors => [] }
      elsif !resource.is_a?(ApplicationRecord) || resource.id
        { key => resource, :errors => errors_for(resource) }
      else
        { key => nil, :errors => errors_for(resource) }
      end
    end

    def errors_for resource, parent_path: ['attributes']
      retval = resource.errors.map do |error|
        attribute = error.attribute
        message = error.message

        path = parent_path + [attribute.to_s.camelize(:lower)]
        retval = { path: path, message: message }

        if !resource.respond_to?(attribute)
          retval
        elsif resource.send(attribute).is_a?(ApplicationRecord)
          [retval] + errors_for(resource.send(attribute), parent_path: path)
        elsif resource.send(attribute).respond_to?(:all)
          [retval] + resource.send(attribute).to_a.map do |child|
            errors_for(child, parent_path: path)
          end
        else
          retval
        end
      end.flatten

      if retval.any?
        Rails.logger.info(
          "VALIDATION ERROR: #{resource.inspect} -> #{retval.inspect}"
        )
      end

      retval
    end

    def current_user
      context[:current_user]
    end

    # Restrict actions based on tournament status.
    #
    # @raise [GraphQL::ExecutionError]
    def restrict_tournament_status! tournament, statuses: ['Active', 'Closed']
      if statuses.include? tournament.status
        raise GraphQL::ExecutionError.new(
          "Action restricted: Tournament status is #{tournament.status}",
          extensions: { code: 'TOURNAMENT_STATUS' }
        )
      end
    end
  end
end
