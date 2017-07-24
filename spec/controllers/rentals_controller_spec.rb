require 'rails_helper'

RSpec.describe RentalsController, type: :controller do
  before(:each) { request.set_header('X-HTTP_AUTHORIZATION', AUTHENTICATION_TOKEN) }

  let(:valid_attributes) { { name: 'Hotel', daily_rate: 100 } }

  describe "GET #index" do
    before do
      create(:hotel)
      create(:vacation_villa)
    end

    it "returns all rentals" do
      get :index, params: {}
      expect(response).to be_success
      expect(json_response.length).to eq 2
    end
  end

  describe "GET #show" do
    let(:hotel) { create(:hotel) }
    it "returns a success response" do
      get :show, params: { id: hotel.to_param }

      expect(response).to be_success
      response = json_response
      expect(response['name']).to eq 'Hotel'
      expect(response['daily_rate']).to eq 100
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Rental" do
        expect {
          post :create, params: {rental: valid_attributes}
        }.to change(Rental, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(rental_url(Rental.last))
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { name: '', daily_rate: '' } }

      it "renders a JSON response with errors for the new rental" do

        post :create, params: {rental: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { daily_rate: 200 } }
      let!(:hotel) { create(:hotel) }
      it "updates the requested rental" do
        put :update, params: { id: hotel.to_param, rental: new_attributes }
        hotel.reload
        expect(hotel.daily_rate).to eq 200

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { name: '', daily_rate: '' } }
      let!(:hotel) { create(:hotel) }
      it "renders a JSON response with errors for the rental" do

        put :update, params: { id: hotel.to_param, rental: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:hotel) { create(:hotel) }

    it "destroys the requested rental" do
      expect {
        delete :destroy, params: { id: hotel.to_param }
      }.to change(Rental, :count).by(-1)
    end
  end

end
