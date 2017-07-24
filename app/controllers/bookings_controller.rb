class BookingsController < ApplicationController
  before_action :set_rental
  before_action :set_booking, only: %i[show update destroy]

  # GET rentals/:rental_id/bookings
  def index
    @bookings = Booking.all

    render json: @bookings
  end

  # GET rentals/:rental_id/bookings/1
  def show
    render json: @booking
  end

  # POST rentals/:rental_id/bookings
  def create
    @booking = @rental.bookings.build(booking_params)

    if @booking.save
      render json: @booking, status: :created, location: rental_booking_url(@rental, @booking)
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT rentals/:rental_id/bookings/1
  def update
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE rentals/:rental_id/bookings/1
  def destroy
    @booking.destroy
  end

  private

  def set_rental
    @rental = Rental.find(params[:rental_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_at, :end_at, :client_email, :price, :rental_id)
  end
end
