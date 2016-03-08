require 'rails_helper'

describe API::V1::Users, type: :request do
  NAMESPACE = '/api/v1'

  let!(:user) { create(:user_admin) }
  let!(:broker_user) { create(:user_broker) }
  let!(:read_only_user) { create(:user) }

  context "GET #{NAMESPACE}/users" do
    it 'returns an array with all users' do
      get "#{NAMESPACE}/users", nil, auth_header(user)
      expect(response).to be_ok
      expect(JSON.parse(response.body)['users'].size).to eq 3
    end
  end

  context "GET #{NAMESPACE}/users/:id" do
    context 'when user exist' do
      it 'returns a specific user' do
        get "#{NAMESPACE}/users/#{user.id}", nil, auth_header(user)
        expect(response).to be_ok
        expect(JSON.parse(response.body)['user']['id']).to eq(user.id)
      end
    end

    context 'when user does not exist' do
      it 'fails with 404 not found code' do
        get "#{NAMESPACE}/users/#{user.id+9999}", nil, auth_header(user)
        expect(response).to be_not_found
      end
    end
  end

  context "POST #{NAMESPACE}/users" do
    let(:user_params) { attributes_for(:user) }

    context 'when all required fields are present' do
      it 'creates the user' do
        post "#{NAMESPACE}/users", user_params, auth_header(user)
        expect(response).to be_created
      end
    end

    context 'when required fields are missing' do
      before { user_params.delete(:name) }

      it 'fails with 400 bad request code' do
        post "#{NAMESPACE}/users", user_params, auth_header(user)
        expect(response).to be_bad_request
      end
    end

    context 'when a guest attempt to create' do
      it 'fails with 403 forbidden code' do
        post "#{NAMESPACE}/users", user_params, auth_header(read_only_user)
        expect(response).to be_forbidden
      end
    end

    context 'when a broker attempt to create' do
      it 'fails with 403 forbidden code' do
        post "#{NAMESPACE}/users", user_params, auth_header(broker_user)
        expect(response).to be_forbidden
      end
    end
  end

  context "PUT #{NAMESPACE}/users/:id" do
    let(:user_params) { { name: 'New User name' } }

    context 'when at least one field is present' do
      it 'updates that field' do
        put "#{NAMESPACE}/users/#{user.id}", user_params, auth_header(user)
        expect(response.status).to eq 204
        expect(user.reload.name).to eq(user_params[:name])
      end
    end

    context 'when it is an empty request' do
      it 'fails with 400 bad request code' do
        put "#{NAMESPACE}/users/#{user.id}", nil, auth_header(user)
        expect(response).to be_bad_request
      end
    end

    context 'when an user without permission attempt to update' do
      it 'fails with 403 forbidden code' do
        put "#{NAMESPACE}/users/#{user.id}", user_params, auth_header(read_only_user)
        expect(response).to be_forbidden
      end
    end

    context 'when an user attempts to update another user' do
      it 'fails with 403 forbidden code' do
        put "#{NAMESPACE}/users/#{user.id}", user_params, auth_header(broker_user)
        expect(response).to be_forbidden
      end
    end
  end

  context "DELETE #{NAMESPACE}/users/:id" do
    context 'when user is admin' do
      it 'deletes the user from the system' do
        delete "#{NAMESPACE}/users/#{broker_user.id}", nil, auth_header(user)
        expect(response).to be_ok
        expect{ broker_user.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when user it deleting himself' do
      it 'deletes the user from the system' do
        delete "#{NAMESPACE}/users/#{broker_user.id}", nil, auth_header(broker_user)
        expect(response).to be_ok
      end
    end

    context 'when user is not admin an attempts to delete another user' do
      it 'fails with 403 forbidden code' do
        delete "#{NAMESPACE}/users/#{user.id}", nil, auth_header(broker_user)
        expect(response).to be_forbidden
      end
    end
  end
end
