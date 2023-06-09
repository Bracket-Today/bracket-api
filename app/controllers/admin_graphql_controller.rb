# frozen_string_literal: true

class AdminGraphqlController < GraphqlController
  def execute
    current_user = gql_devise_context(User)[:current_resource]

    unless current_user && current_user.admin?
      head :unauthorized and return
    end

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: User.by_uuid(request.headers['HTTP_X_UUID'])
    }
    result = AdminSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end
end
