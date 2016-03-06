require 'rails_helper'

describe PropertyPolicy do
  subject { PropertyPolicy.new(user, record) }

  context "being a guest" do
    let(:user) { create(:user) }
    let(:record) { create(:property, user: user) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "being a broker" do
    let(:user) { create(:user_broker) }
    let(:another_user) { create(:user_broker) }
    let(:record) { create(:property, user: user) }

    it { is_expected.to permit_action(:create) }

    context 'actions for property created by himself' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'actions for property created by another user' do
      let(:record) { create(:property, user: another_user) }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

  end

  context "being an administrator" do
    let(:user) { create(:user_admin) }
    let(:another_user) { create(:user_broker) }
    let(:record) { create(:property, user: another_user) }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
