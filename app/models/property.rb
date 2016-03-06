class Property < ActiveRecord::Base

  enum goal: [:buy, :rent]
  enum property_type: [:farm, :home, :apartment, :land, :studio]

  validates_presence_of :name, :price

  belongs_to :user
  has_one :property_info

end
