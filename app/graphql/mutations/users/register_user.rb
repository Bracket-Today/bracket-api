# frozen_string_literal: true

module Mutations
  module Users
    class RegisterUser < Mutations::BaseMutation
      include GraphqlDevise::ControllerMethods
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      field :authenticatable, Types::UserType, null: false
      field :credentials, GraphqlDevise::Types::CredentialType, null: true

      def resolve(**attributes)
        if current_user.update(attributes)
          current_user.send_confirmation_instructions(
            redirect_url: DeviseTokenAuth.default_confirm_success_url,
            template_path: ['graphql_devise/mailer']
          )

          result = { authenticatable: current_user }

          if current_user.active_for_authentication?
            result[:credentials] = generate_auth_headers(current_user)
          end

          result
        else
          current_user.try(:clean_up_passwords)

          raise_user_error_list(
            I18n.t('graphql_devise.registration_failed'),
            errors: resource.errors.full_messages
          )
        end
      end
    end
  end
end
