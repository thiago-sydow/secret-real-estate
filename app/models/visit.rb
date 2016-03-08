class Visit < ActiveRecord::Base
  belongs_to :visitable, polymorphic: true

end
