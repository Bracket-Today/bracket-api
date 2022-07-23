# frozen_string_literal: true

class AdminSchema < GraphQL::Schema
  mutation(Types::AdminMutationType)
  query(Types::AdminQueryType)

  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    # Raise a graphql-friendly error with a custom message
    raise GraphQL::ExecutionError.new(
      "#{field.type.unwrap.graphql_name} not found",
      extensions: { code: 'NOT_FOUND' }
    )
  end

  def self.unauthorized_object(error)
    raise GraphQL::ExecutionError,
      "An object of type #{error.type.graphql_name} was hidden due to permissions"
  end
end
