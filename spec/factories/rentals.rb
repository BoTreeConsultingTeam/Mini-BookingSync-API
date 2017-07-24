FactoryGirl.define do
  factory :hotel, class: Rental do
    name 'Hotel'
    daily_rate 100
  end

  factory :vacation_villa, class: Rental do
    name 'Vacation Villa'
    daily_rate 500
  end
end
