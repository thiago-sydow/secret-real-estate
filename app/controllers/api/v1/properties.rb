module API
  module V1
    class Properties < Grape::API
      include API::V1::Defaults
      helpers PropertyHelpers

      resource :properties, desc: 'Properties Endpoint' do
        desc 'Return the most Viewed Properties.'
        get '/most-viewed' do
          present Property.most_viewed, with: API::V1::Entities::Property
        end

        desc 'Return all Properties.'
        get '/' do
          present Property.all, with: API::V1::Entities::Property
        end

        desc 'Return the specified property if exists.'
        get ':id' do
          property = Property.find(params[:id])
          property.visits.create!({visit_time: Time.current})
          present property, with: API::V1::Entities::Property
        end

        desc 'Create Property.' do
          detail 'Create a new Property in the system. Note that your role must be broker or admin'
        end
        params do
          requires :name, type: String, allow_blank: false, desc: 'The name of the property'
          requires :property_type, type: Symbol, allow_blank: false, values: [:farm, :home, :apartment, :land, :studio], desc: 'The type of the property'
          requires :goal, type: Symbol, allow_blank: false, values: [:buy, :rent], desc: 'The goal of the property'
          requires :price, type: Float, allow_blank: false, desc: 'The price of the property'
          use :property_info
        end
        post '/' do
          authorize Property, :create?

          current_user.properties.create!(filtered_params(params))

          body {}
        end

        desc 'Update Property.' do
          detail 'Update an existing Property in the system. Note that your role must be an admin.' +
          'If you are a broker, you can only edit your own inserted Properties'
        end
        params do
          optional :name, type: String, allow_blank: false, desc: 'The name of the property'
          optional :property_type, type: Symbol, allow_blank: false, values: [:farm, :home, :apartment, :land, :studio], desc: 'The type of the property'
          optional :goal, type: Symbol, allow_blank: false, values: [:buy, :rent], desc: 'The goal of the property'
          optional :price, type: Float, allow_blank: false, desc: 'The price of the property'
          use :property_info
          at_least_one_of :name, :property_type, :goal, :price, :property_info_attributes
        end
        put ':id' do
          property = Property.find(params[:id])
          authorize property, :update?

          property.update!(filtered_params(params))

          body false
        end

        desc 'Delete Property.' do
          detail 'Exclude an existing Property from the system. Note that your role must be Admin.' +
          'If you are a Broker, you can only delete your own inserted Properties'
        end
        delete ':id' do
          property = Property.find(params[:id])
          authorize property, :destroy?

          property.destroy!
        end
      end

    end
  end
end
