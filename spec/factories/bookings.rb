FactoryGirl.define do
  factory :booking do
    start_at { Date.tomorrow }
    end_at { Date.tomorrow + 1.day }
    client_email 'example@bookingsync.com'
    price 100
    association :rental, factory: :hotel

    factory :villa_booking do
      price 500
      association :rental, factory: :vacation_villa
    end
  end
end
