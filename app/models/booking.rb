class Booking < ApplicationRecord
  belongs_to :rental

  validates :client_email, presence: true, email: true
  validates :start_at, :end_at, presence: true
  validate :end_at_must_be_greater_or_equal_start_at, if: ['start_at.present?', 'end_at.present?']
  validate :cannot_overlap

  before_save :update_price

  def days
    (end_at.to_date - start_at.to_date).to_i
  end

  def overlaps?
    self.class.where('(start_at BETWEEN :start_at AND :end_at) OR (end_at BETWEEN :start_at AND :end_at)',
                    start_at: start_at, end_at: end_at)
              .where.not(id: id)
              .count > 0
  end

  private

  def update_price
    self.price = rental.daily_rate * days
  end

  def end_at_must_be_greater_or_equal_start_at
    errors.add(:base, 'The checkout date must be same or later than check-in') if days < 1
  end

  def cannot_overlap
    errors.add(:base, 'The Rental is already booked for given period') if overlaps?
  end
end
