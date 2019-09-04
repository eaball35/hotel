require_relative 'test_helper'

describe 'reservation tests' do
  it 'should create a new insance of reservation with given room and booking date ranges' do
    room = Room.new(1,200)
    booking_dates = DateChecker.new('Jan, 1, 2019', 'Jan 4, 2019').booking_date_range
    reservation_test = Reservation.new(room, booking_dates)

    expect(reservation_test).must_be_instance_of Reservation
    expect(reservation_test.room).must_equal room
    expect(reservation_test.booking_date_range).must_equal booking_dates
  end

end