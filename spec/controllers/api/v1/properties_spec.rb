require 'rails_helper'

describe API::V1::Properties, type: :request do
  NAMESPACE = '/api/v1'

  let!(:user) { create(:user_broker) }
  let!(:read_only_user) { create(:user) }

  context "GET #{NAMESPACE}/properties" do

    context 'when a property exists' do
      let!(:properties) { create_list(:property, 2, user: user) }

      it 'returns an array with all properties' do
        get "#{NAMESPACE}/properties", nil, auth_header(user)
        expect(response).to be_ok
        expect(JSON.parse(response.body).size).to eq 2
      end
    end

    context 'when no properties exists' do
      it 'returns an empty json array' do
        get "#{NAMESPACE}/properties", nil, auth_header(user)
        expect(response).to be_ok
        expect(JSON.parse(response.body)).to be_empty
      end
    end
  end

  context "GET #{NAMESPACE}/properties/:id" do
    let!(:property) { create(:property, user: user) }

    context 'when property exist' do
      it 'returns a specific property' do
        get "#{NAMESPACE}/properties/#{property.id}", nil, auth_header(user)
        expect(response).to be_ok
        expect(JSON.parse(response.body)['id']).to eq(property.id)
      end
    end

    context 'when property does not exist' do
      it 'fails with 404 not found code' do
        get "#{NAMESPACE}/properties/#{property.id+9999}", nil, auth_header(user)
        expect(response).to be_not_found
      end
    end
  end

  context "POST #{NAMESPACE}/properties" do
    context 'when all required fields are present' do
      let(:property_params) { attributes_for(:property) }

      it 'returns a specific property' do
        post "#{NAMESPACE}/properties", property_params, auth_header(user)
        expect(response).to be_created
      end
    end

    context 'when required fields are missing' do
      let(:property_params) { attributes_for(:property) }

      before { property_params.delete(:name) }

      it 'returns a specific property' do
        post "#{NAMESPACE}/properties", property_params, auth_header(user)
        expect(response).to be_bad_request
      end
    end

    context 'when an user without permission attempt to create' do
      let(:property_params) { attributes_for(:property) }

      it 'returns a specific property' do
        post "#{NAMESPACE}/properties", property_params, auth_header(read_only_user)
        expect(response).to be_forbidden
      end
    end
  end

  context "PUT #{NAMESPACE}/properties/:id" do
    let!(:property) { create(:property, user: user) }

    context 'when at least one field is present' do
      let(:property_params) { { name: 'New name' } }

      it 'updates that field' do
        put "#{NAMESPACE}/properties/#{property.id}", property_params, auth_header(user)
        expect(response.status).to eq 204
        expect(property.reload.name).to eq(property_params[:name])
      end
    end

    context 'when it is an empty request' do
      it 'fails with 400 bad request code' do
        put "#{NAMESPACE}/properties/#{property.id}", nil, auth_header(user)
        expect(response).to be_bad_request
      end
    end

    context 'when an user without permission attempt to update' do
      let(:property_params) { { name: 'New name' } }

      it 'fails with 403 bad request code' do
        put "#{NAMESPACE}/properties/#{property.id}", property_params, auth_header(read_only_user)
        expect(response).to be_forbidden
      end
    end

    context 'when an user attempts to update another user property' do
      let!(:another_user) { create(:user_broker) }
      let!(:property2) { create(:property, user: another_user) }
      let(:property_params) { { name: 'New name' } }

      it 'fails with 403 bad request code' do
        put "#{NAMESPACE}/properties/#{property2.id}", property_params, auth_header(user)
        expect(response).to be_forbidden
      end
    end
  end
end
