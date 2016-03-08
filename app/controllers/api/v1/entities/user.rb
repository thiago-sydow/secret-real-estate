module API
  module V1
    module Entities
      class User < Grape::Entity
        root 'users', 'user'

        expose :id
        expose :name
        expose :email

        expose :property_count do |user|
          user.properties.count
        end

        expose :total_visits do |user|
          user.try(:total_visits) || user.visits.count
        end
      end
    end
  end
end
