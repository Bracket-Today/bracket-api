# frozen_string_literal: true

module GraphQL::Schema::Member::HasArguments::ArgumentObjectLoader
  def object_from_id type, id, context
    type_name = type.name.split('::')[-1].sub(/Type\Z/, '')
    Object.const_get(type_name).find_by_id(id)
  end
end

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

  rescue_from StandardError do |exception, obj, args, ctx|
    PtiIssues.handle_exception(
      exception: exception,
      request: ctx[:request],
    )

    raise
  end

  def self.unauthorized_object(error)
    raise GraphQL::ExecutionError,
      "An object of type #{error.type.graphql_name} was hidden due to permissions"
  end
end
