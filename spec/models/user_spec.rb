require 'rails_helper'

RSpec.describe User, type: :model do

  context 'associations' do
    it { is_expected.to have_many :properties }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :role }
  end

  context 'authenticate user' do
    let(:user) { create(:user) }

    it { expect(user.valid_password?('password')).to be }
    it { expect(user.valid_password?('falsepassword')).not_to be }
  end

  context 'callbacks' do
    context '.after_initialize' do
      let(:user) { build(:user) }

      it { expect(user.guest?).to be_truthy }
    end
  end

end
