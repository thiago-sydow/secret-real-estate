module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resource :users, desc: 'Users Endpoint' do
        desc 'Return the most popular users.'
        get '/most-popular' do
          present User.most_viewed, with: API::V1::Entities::User
        end

        desc 'Return all Users.'
        get '/' do
          present User.all, with: API::V1::Entities::User
        end

        desc 'Return the specified user if exists.'
        get ':id' do
          user = User.find(params[:id])
          user.visits.create!({visit_time: Time.current})
          present user, with: API::V1::Entities::User
        end

        desc 'Create User.' do
          detail 'Create a new User in the system. Note that your role must be Admin'
        end
        params do
          requires :name, type: String, desc: 'The name of the User'
          requires :email, type: String, regexp: /.+@.+/, desc: 'Email of the User'
          requires :password, type: String, desc: 'Password for the User'
          requires :role, type: Symbol, values: [:guest, :admin, :broker], desc: 'The role of the User'
        end
        post '/' do
          authorize User, :create?

          User.create!(filtered_params(params))

          body {}
        end

        desc 'Update User.' do
          detail 'Update an existing User in the system. Note that to update role you must be an admin.'
        end
        params do
          optional :name, type: String, desc: 'The name of the User'
          optional :password, type: String, desc: 'Password for the User'
          optional :role, type: Symbol, values: [:guest, :admin, :broker], desc: 'The role of the User'
          at_least_one_of :name, :password, :role
        end
        put ':id' do
          user = User.find(params[:id])
          authorize user, :update?

          params_to_update = filtered_params(params)

          params_to_update.delete('role') unless current_user.admin?

          user.update!(params_to_update)

          body false
        end

        desc 'Delete User.' do
          detail 'Exclude an existing User from the system. Note that your role must be Admin.' +
          'If you are a Broker, you can only delete yourself'
        end
        delete ':id' do
          user = User.find(params[:id])
          authorize user, :destroy?

          user.destroy!
        end
      end

    end
  end
end
