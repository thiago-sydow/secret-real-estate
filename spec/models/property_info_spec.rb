require 'rails_helper'

RSpec.describe PropertyInfo, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :property }
  end
end
