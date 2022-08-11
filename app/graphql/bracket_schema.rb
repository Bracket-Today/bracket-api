module GraphQL::Schema::Member::HasArguments::ArgumentObjectLoader
  SHORT_CODE_TYPES = []

  def object_from_id type, id, context
    type_name = type.name.split('::')[-1].sub(/Type\Z/, '')
    if SHORT_CODE_TYPES.include?(type_name)
      ShortCode.resource(id, type: type_name)
    else
      Object.const_get(type_name).find_by_id(id)
    end
  end
end

class BracketSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

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
