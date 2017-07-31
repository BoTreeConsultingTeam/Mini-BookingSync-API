require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe '#days' do
    let!(:booking) { create(:booking) }

    it 'returns number of days the rental is booked' do
      expect(booking.days).to eq 1
    end
  end

  describe 'when checkout date time is earlier than check in' do
    let(:booking) { build(:booking, end_at: 1.day.ago) }

    it 'does not create booking' do
      expect(booking.save).to be_falsey
      expect(booking.errors.full_messages).to include 'The checkout date must be same or later than check-in'
    end
  end

  describe 'overlaps?' do
    let!(:booking) { create(:booking) }

    it 'returns false when given date range overlaps' do
      another_booking = build(:booking, rental_id: booking.rental.id)
      expect(another_booking).to be_overlaps

      another_booking = build(:booking, start_at: booking.end_at, end_at: booking.end_at + 2.days, rental_id: booking.rental.id)
      expect(another_booking).to be_overlaps

      another_booking = build(:booking, start_at: booking.start_at - 2.days, end_at: booking.start_at, rental_id: booking.rental.id)
      expect(another_booking).to be_overlaps
    end

    it 'returns true when given date range does not overlap' do
      another_booking = build(:booking, start_at: booking.end_at + 2.days, end_at: booking.end_at + 3.days, rental_id: booking.rental.id)
      expect(another_booking).not_to be_overlaps
    end
  end

  describe 'when booking date overlaps other bookings' do
    let!(:booking) { create(:booking) }

    it 'should not save record for same rental' do
      another_booking = build(:booking, start_at: Date.today, end_at: Date.tomorrow, rental_id: booking.rental.id)
      another_booking.save

      expect(another_booking).not_to be_persisted
      expect(another_booking.errors.full_messages).to include 'The Rental is already booked for given period'
    end

    it 'should save record for other rental for same date' do
      another_booking = build(:vacation_villa)
      another_booking.save

      expect(another_booking).to be_persisted
    end
  end
end
