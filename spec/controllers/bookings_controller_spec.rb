require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  before(:each) { request.set_header('X-HTTP_AUTHORIZATION', AUTHENTICATION_TOKEN) }

  let!(:hotel) { create(:hotel) }

  let(:valid_attributes) do
    { start_at: Time.zone.now, end_at: 1.day.from_now, client_email: 'example@bookingsync.com' }
  end

  describe "GET #index" do
    let!(:booking1) { create(:booking) }
    let!(:booking2) { create(:booking, start_at: booking1.end_at + 1.day, end_at: booking1.end_at + 2.days) }

    it "returns all bookings of given rental" do
      get :index, params: { rental_id: hotel.to_param }
      expect(response).to be_success
      expect(json_response.length).to eq 2
    end
  end

  describe "GET #show" do
    let!(:booking) { create(:booking) }

    it "returns a booking" do
      get :show, params: { rental_id: hotel.to_param, id: booking.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Booking" do
        expect {
          post :create, params: { rental_id: hotel.to_param, booking: valid_attributes }
        }.to change(Booking, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(rental_booking_url(hotel, Booking.last))
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { client_email: '' } }

      it "renders a JSON response with errors for the new booking" do

        post :create, params: { rental_id: hotel.to_param, booking: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with overlaping time" do
      let!(:booking) { create(:booking) }

      it "renders a JSON response with errors for the new booking" do
        params = { start_at: booking.end_at, end_at: booking.end_at + 2.days, client_email: 'test@example.com' }

        post :create, params: { rental_id: hotel.to_param, booking: params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(json_response['errors']).to include 'The Rental is already booked for given period'
      end
    end
  end

  describe "PUT #update" do
    let!(:booking) { create(:booking) }

    context "with valid params" do
      let(:new_attributes) do
        { start_at: 2.days.from_now, end_at: 4.days.from_now, client_email: 'async@bookingsync.com' }
      end

      it "updates the requested booking" do
        expect(booking.days).to eq 1

        put :update, params: { rental_id: hotel.to_param, id: booking.to_param, booking: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')

        booking.reload
        expect(booking.start_at).to be_within(1.second).of(2.days.from_now)
        expect(booking.days).to eq 2
        expect(booking.client_email).to eq 'async@bookingsync.com'
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { client_email: '' } }

      it "renders a JSON response with errors for the booking" do
        put :update, params: { rental_id: hotel.to_param, id: booking.to_param, booking: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with overlaping time" do
      let!(:another_booking) { create(:booking, start_at: booking.end_at + 1.day, end_at: booking.end_at + 2.days) }

      it "renders a JSON response with errors for the booking" do
        params = { start_at: booking.end_at, end_at: booking.end_at + 2.days, client_email: 'test@example.com' }

        put :update, params: { rental_id: hotel.to_param, id: another_booking.to_param, booking: params}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(json_response['errors']).to include 'The Rental is already booked for given period'
      end
    end

  end

  describe "DELETE #destroy" do
    let!(:booking) { create(:booking) }

    it "destroys the requested booking" do
      expect {
        delete :destroy, params: { rental_id: hotel.to_param, id: booking.to_param }
      }.to change(Booking, :count).by(-1)
    end
  end

end
