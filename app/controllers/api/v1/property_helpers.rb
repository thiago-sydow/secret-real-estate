module API
  module V1
    module PropertyHelpers
      extend Grape::API::Helpers

      params :property_info do
        optional :property_info_attributes, type: Hash do
          optional :bedrooms, type: Integer, desc: 'Number of bedrooms of the property'
          optional :bathrooms, type: Integer, desc: 'Number of bathrooms of the property'
          optional :car_spaces, type: Integer, desc: 'Number of car spaces of the property'
          optional :square_footage, type: String, desc: 'Square footage of the property'
          at_least_one_of :bedrooms, :bathrooms, :car_spaces, :square_footage
        end
      end
    end
  end
end
