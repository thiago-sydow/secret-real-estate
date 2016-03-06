class Property < ActiveRecord::Base

  enum goal: [:buy, :rent]
  enum property_type: [:farm, :home, :apartment, :land, :studio]

  validates_presence_of :name, :price

  belongs_to :user
  has_one :property_info, dependent: :destroy
  has_many :visits, as: :visitable

  accepts_nested_attributes_for :property_info, reject_if: :all_blank

  def self.most_viewed
    joins(:visits).
    select('properties.*, count(visits.visitable_id) as total_visits').
    group('properties.id').order('total_visits desc')
  end
end
