require_relative 'test_helper'

describe 'reservation tests' do
  
  let (:booking_dates)  {
    DateChecker.new('Jan, 1, 2019', 'Jan 4, 2019').booking_date_range 
  }
  let (:room)  {
    Room.new(200) 
  }
  let (:reservation)  {
    Reservation.new(room, booking_dates) 
  }

  it 'should create a new insance of reservation with given room and booking date ranges' do
    expect(reservation).must_be_instance_of Reservation
    expect(reservation.room).must_equal room
    expect(reservation.booking_date_range).must_equal booking_dates
  end

  it 'should calculate reservation price using room and dates' do
    expect(reservation.price).must_equal 600
  end
end