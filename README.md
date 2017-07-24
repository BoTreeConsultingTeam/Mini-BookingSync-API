# README

RESTful JSON API with 2 endpoints: Rentals and Bookings with full CRUD. 

Rental is something that you can book for a particular period of time (like a vacation villa or a hotel) and Booking is a reservation for given Rental for a particular period of time.

The API is authenticated by a token (hardcoded in `ApplicationController`).

Rental has `name` attribute, `daily_rate` attribute and has many `bookings`.

Booking has `start_at` and `end_at` `datetime` attributes which indicate the time period of the reservation, `client_email` attribute, just to know for whom it is supposed to be and `price` attribute, which will be the price for this booking.

Price calculation for the booking : 
  only `daily_rate`  is considered when calculating the price.
  If the rental's `daily_price` is equal to `100`, the booking's `price` for `3` days should be equal to `300`, for `5` days it should be `500` etc.

All attributes for both Rentals and Bookings are required.

Other validations:
- the dates for bookings don't overlap
- the price for given period is valid when creating a booking
- the reservation should be possible for at least one night / day stay



#### Setup the Application

`bundle install`

`rake db:setup`

#### How to run the test suite

`rspeec spec`

