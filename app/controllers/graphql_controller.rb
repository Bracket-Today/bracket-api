class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    devise_context = gql_devise_context(User)

    context = devise_context.merge({
      current_user: (
        devise_context[:current_resource] ||
        User.by_uuid(request.headers['HTTP_X_UUID'])
      )
    })

    result = BracketSchema.execute(
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

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development exception
    logger.error exception.message
    logger.error exception.backtrace.join("\n")

    PtiIssues.handle_exception exception: exception, request: request

    render json: {
      errors: [{
        message: exception.message,
        backtrace: exception.backtrace
      }], data: {}
    }, status: 500
  end
end
