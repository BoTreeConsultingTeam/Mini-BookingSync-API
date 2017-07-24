Rails.application.routes.draw do
  resources :rentals do
    resources :bookings
  end
end
