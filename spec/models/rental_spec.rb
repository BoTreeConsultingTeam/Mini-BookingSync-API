require 'rails_helper'

RSpec.describe Rental, type: :model do
  describe '.available' do
    let!(:rental) { create(:hotel) }

    context 'without any booking' do
      it 'returns available rentals' do
        expect(Rental.available(Date.tomorrow, Date.tomorrow + 1.day)).to include rental
      end
    end

    context 'when has some bookings' do
      let!(:booking1) { build(:booking, rental_id: rental.id) }
      let!(:booking2) { build(:booking, start_at: Date.tomorrow + 2.days, end_at: Date.tomorrow + 3.days, rental_id: rental.id) }
      let!(:booking3) { build(:villa_booking) }

      it 'returns available' do
        expect(Rental.available(Date.tomorrow, Date.tomorrow + 2.days).count).to eq 2
      end
    end
  end
end