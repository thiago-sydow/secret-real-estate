class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:admin, :broker, :guest]

  validates_presence_of :name, :role

  has_many :properties
  has_many :visits, as: :visitable

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
   self.role ||= :guest
  end

  def self.most_viewed
    joins(:visits).
    select('users.*, count(visits.visitable_id) as total_visits').
    group('users.id').order('total_visits desc')
  end
end
