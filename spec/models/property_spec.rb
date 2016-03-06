require 'rails_helper'

RSpec.describe Property, type: :model do

  context 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_one :property_info }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :price }
  end

end
