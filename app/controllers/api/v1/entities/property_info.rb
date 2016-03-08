module API
  module V1
    module Entities
      class PropertyInfo < Grape::Entity
        expose :bedrooms
        expose :bathrooms
        expose :car_spaces
        expose :square_footage
      end
    end
  end
end
