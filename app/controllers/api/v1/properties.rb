module API
  module V1
    class Properties < Grape::API
      include API::V1::Defaults

      resource :properties, desc: 'Properties Endpoint' do
        desc 'Return all Properties.'
        get '/' do
          Property.all
        end

        desc 'Return the specified property if exists.'
        get ':id' do
          Property.find(params[:id])
        end

        desc 'Create Property.' do
          detail 'Create a new Property in the system. Note that your role must be broker or admin'
        end
        params do
          requires :name, type: String, desc: 'The name of the property'
          requires :property_type, type: Symbol, values: [:farm, :home, :apartment, :land, :studio], desc: 'The type of the property'
          requires :goal, type: Symbol, values: [:buy, :rent], desc: 'The goal of the property'
          requires :price, type: Float, desc: 'The price of the property'
          optional :property_info_attributes, type: Hash do
            optional :bedrooms, type: Integer, desc: 'Number of bedrooms of the property'
            optional :bathrooms, type: Integer, desc: 'Number of bathrooms of the property'
            optional :car_spaces, type: Integer, desc: 'Number of car spaces of the property'
            optional :square_footage, type: String, desc: 'Square footage of the property'
            at_least_one_of :bedrooms, :bathrooms, :car_spaces, :square_footage
          end
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
          optional :name, type: String, desc: 'The name of the property'
          optional :property_type, type: Symbol, values: [:farm, :home, :apartment, :land, :studio], desc: 'The type of the property'
          optional :goal, type: Symbol, values: [:buy, :rent], desc: 'The goal of the property'
          optional :price, type: Float, desc: 'The price of the property'
          optional :property_info_attributes, type: Hash do
            optional :bedrooms, type: Integer, desc: 'Number of bedrooms of the property'
            optional :bathrooms, type: Integer, desc: 'Number of bathrooms of the property'
            optional :car_spaces, type: Integer, desc: 'Number of car spaces of the property'
            optional :square_footage, type: String, desc: 'Square footage of the property'
            at_least_one_of :bedrooms, :bathrooms, :car_spaces, :square_footage
          end
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
