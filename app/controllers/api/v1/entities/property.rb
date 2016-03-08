module API
  module V1
    module Entities
      class Property < Grape::Entity
        root 'properties', 'property'

        format_with(:iso_timestamp) { |dt| dt.iso8601 }

        expose :id
        expose :property_type
        expose :name
        expose :goal
        expose :description
        expose :price

        expose :user do |prop|
          prop.user.name
        end

        expose :property_info, using: API::V1::Entities::PropertyInfo

        with_options(format_with: :iso_timestamp) do
          expose :created_at
          expose :updated_at
        end

        expose :total_visits do |prop|
          prop.try(:total_visits) || prop.visits.count
        end
      end
    end
  end
end
