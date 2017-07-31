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
      another_booking = build(:booking)
      expect(another_booking).to be_overlaps

      another_booking = build(:booking, start_at: booking.end_at, end_at: booking.end_at + 2.days)
      expect(another_booking).to be_overlaps

      another_booking = build(:booking, start_at: booking.start_at - 2.days, end_at: booking.start_at)
      expect(another_booking).to be_overlaps
    end

    it 'returns true when given date range does not overlap' do
      expect(booking).not_to be_overlaps, 'Should exclude self from the comparision'

      another_booking = build(:booking, start_at: booking.end_at + 2.days, end_at: booking.end_at + 3.days)
      expect(another_booking).not_to be_overlaps
    end
  end

  describe 'when booking date overlaps other bookings' do
    let!(:booking) { create(:booking) }

    it 'should not save record' do
      another_booking = build(:booking, start_at: Date.today, end_at: Date.tomorrow)
      another_booking.save

      expect(another_booking).not_to be_persisted
      expect(another_booking.errors.full_messages).to include 'The Rental is already booked for given period'
    end
  end
end
