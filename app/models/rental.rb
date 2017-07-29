class Rental < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :name, :daily_rate, presence: true
end
