class Rental < ApplicationRecord
  has_many :bookings

  validates :name, :daily_rate, presence: true
end
