module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        http_basic do |username, password|
          user = find_user(username)
          valid_user = user && user.valid_password?(password)
          @current_user = user if valid_user
          valid_user
        end

        helpers do

          def current_user
            @current_user
          end

          def find_user(email)
            User.find_by_email(email)
          end

          def authorize(record, method)
            policy = Pundit.policy!(current_user, record)

            unless policy.public_send(method)
              raise Pundit::NotAuthorizedError, query: method, record: record, policy: policy
            end

            true
          end

          def filtered_params(params)
            declared(params, include_missing: false).to_hash
          end
        end
      end

    end
  end
end
