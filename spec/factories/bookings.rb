FactoryGirl.define do
  factory :booking do
    start_at { Time.zone.now }
    end_at { 1.day.from_now }
    client_email 'example@bookingsync.com'
    price 100
    association :rental, factory: :hotel
  end
end
