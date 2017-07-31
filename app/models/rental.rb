class Rental < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :name, :daily_rate, presence: true

  def self.available(start_at,end_at)
    joins(:bookings).where.not('(start_at BETWEEN :start_at AND :end_at) OR (end_at BETWEEN :start_at AND :end_at)',start_at: start_at, end_at: end_at).uniq
  end
end
