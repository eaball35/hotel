require_relative 'test_helper'

describe 'reservation tests' do
  it 'should create a new insance of reservation with given room and booking date ranges' do
    room = Room.new(1,200)
    booking_dates = DateChecker.new('Jan, 1, 2019', 'Jan 4, 2019').booking_date_range
    reservation = Reservation.new(room, booking_dates)

    expect(reservation).must_be_instance_of Reservation
    expect(reservation.room).must_equal room
    expect(reservation.booking_date_range).must_equal booking_dates
  end

  it 'should calculate reservation price using room and dates' do
    room = Room.new(1,200)
    booking_dates = DateChecker.new('Jan, 1, 2019', 'Jan 4, 2019').booking_date_range
    reservation = Reservation.new(room, booking_dates)

    expect(reservation.price).must_equal 600
  end

end